import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../native/external_gps_detector.dart';

class LocationService extends ChangeNotifier {
  String _latitude = '未知';
  String _longitude = '未知';
  String _accuracy = '未知';
  String _externalDeviceStatus = '未检测';
  bool _isUsingExternalDevice = false;
  String _errorMessage = '';
  bool _isLoading = false;

  String get latitude => _latitude;
  String get longitude => _longitude;
  String get accuracy => _accuracy;
  String get externalDeviceStatus => _externalDeviceStatus;
  bool get isUsingExternalDevice => _isUsingExternalDevice;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> checkLocation() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // 检查定位服务是否启用
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = '定位服务未开启，请在设置中开启';
        _externalDeviceStatus = '无法检测';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 请求权限
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = '定位权限被拒绝，请在设置中允许';
          _externalDeviceStatus = '无法检测';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = '定位权限被永久拒绝，请在系统设置中手动开启';
        _externalDeviceStatus = '无法检测';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 获取当前位置
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      _latitude = '${position.latitude.toStringAsFixed(6)}°';
      _longitude = '${position.longitude.toStringAsFixed(6)}°';
      _accuracy = '±${position.accuracy.toStringAsFixed(2)}米';

      // 检测外部GPS设备（增强版：使用原生iOS API）
      await _checkExternalGPSDevicesEnhanced(position);

      // 检查高精度定位（可能表示使用了外部GPS）
      if (position.accuracy < 5.0 && !_isUsingExternalDevice) {
        _externalDeviceStatus = '未检测到外部设备（检测到高精度定位）';
      }
    } catch (e) {
      _errorMessage = '定位失败: ${e.toString()}';
      _latitude = '获取失败';
      _longitude = '获取失败';
      _accuracy = '获取失败';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 增强版外部GPS检测（支持iOS原生ExternalAccessory）
  Future<void> _checkExternalGPSDevicesEnhanced(Position position) async {
    try {
      if (Platform.isIOS) {
        // iOS平台：使用原生ExternalAccessory API
        await _checkExternalGPSiOS(position);
      } else if (Platform.isAndroid) {
        // Android平台：使用蓝牙检测
        await _checkExternalGPSAndroid();
      }
    } catch (e) {
      print('检测外部设备时出错: $e');
      _externalDeviceStatus = '检测外部设备时出错';
      _isUsingExternalDevice = false;
    }

    notifyListeners();
  }

  /// iOS专用：使用ExternalAccessory框架和sourceInformation检测（完全对应iOS原生版）
  Future<void> _checkExternalGPSiOS(Position position) async {
    // 1. 使用iOS原生CLLocationManager获取包含sourceInformation的位置
    // （完全对应iOS原生版LocationManager.swift:100-111的sourceInformation检测）
    final locationWithSource = await ExternalGPSDetector.getLocationWithSource();

    if (locationWithSource != null && locationWithSource['error'] != true) {
      // 检查iOS 15+ sourceInformation特性
      if (locationWithSource['hasSourceInfo'] == true &&
          locationWithSource['isProducedByAccessory'] == true) {
        _isUsingExternalDevice = true;
        _externalDeviceStatus = '使用外部定位设备（系统检测）';
        print('✓ sourceInformation检测: 位置来自外部附件');
        return;
      }

      // 检查高精度（完全对应iOS原生版LocationManager.swift:114-117）
      if (locationWithSource['isHighAccuracy'] == true) {
        print('检测到高精度定位（可能使用外部GPS）');
      }
    }

    // 2. 检查ExternalAccessory连接的设备
    // （完全对应iOS原生版LocationManager.swift:55-87的ExternalAccessory检测）
    final externalGPSResult = await ExternalGPSDetector.checkExternalGPS();

    if (externalGPSResult != null && externalGPSResult['hasExternalGPS'] == true) {
      _isUsingExternalDevice = true;
      final deviceCount = externalGPSResult['deviceCount'] ?? 0;
      final devices = externalGPSResult['devices'] as List? ?? [];

      if (devices.isNotEmpty) {
        final deviceNames = devices
            .map((d) => d['name'] ?? '未知设备')
            .join(', ');
        _externalDeviceStatus = '已连接外部GPS设备 ($deviceCount个): $deviceNames';

        // 打印设备详情（与iOS原生版一致）
        for (var device in devices) {
          print('外部GPS设备: ${device['name']}, 制造商: ${device['manufacturer']}');
          if (device['protocols'] != null) {
            print('  支持协议: ${device['protocols']}');
          }
        }
      } else {
        _externalDeviceStatus = '已连接外部GPS设备 ($deviceCount个)';
      }
      return;
    }

    // 3. 如果没有检测到ExternalAccessory设备，尝试蓝牙检测
    await _checkBluetoothGPS();

    // 4. 如果还是没有检测到，标记为未连接
    // （完全对应iOS原生版LocationManager.swift:77-86的逻辑）
    if (!_isUsingExternalDevice) {
      final hasOtherAccessories = externalGPSResult?['hasOtherAccessories'] ?? false;
      if (hasOtherAccessories) {
        _externalDeviceStatus = '已连接外部设备（非GPS）';
      } else {
        _externalDeviceStatus = '未连接外部定位设备';
      }
    }
  }

  /// Android专用：使用蓝牙检测
  Future<void> _checkExternalGPSAndroid() async {
    // 请求蓝牙权限
    var bluetoothStatus = await Permission.bluetooth.request();
    var bluetoothScanStatus = await Permission.bluetoothScan.request();
    var bluetoothConnectStatus = await Permission.bluetoothConnect.request();

    if (bluetoothStatus.isDenied ||
        bluetoothScanStatus.isDenied ||
        bluetoothConnectStatus.isDenied) {
      _externalDeviceStatus = '需要蓝牙权限以检测外部GPS设备';
      return;
    }

    await _checkBluetoothGPS();
  }

  /// 通用蓝牙GPS检测方法
  Future<void> _checkBluetoothGPS() async {
    try {
      // 请求蓝牙权限
      if (Platform.isIOS) {
        var bluetoothStatus = await Permission.bluetooth.request();
        if (bluetoothStatus.isDenied) {
          if (!_isUsingExternalDevice) {
            _externalDeviceStatus = '需要蓝牙权限以检测蓝牙GPS设备';
          }
          return;
        }
      }

      // 检查蓝牙是否可用
      if (await FlutterBluePlus.isSupported == false) {
        if (!_isUsingExternalDevice) {
          _externalDeviceStatus = '设备不支持蓝牙';
        }
        return;
      }

      // 获取已连接的蓝牙设备
      List<BluetoothDevice> connectedDevices =
          await FlutterBluePlus.connectedDevices;

      if (connectedDevices.isEmpty) {
        if (!_isUsingExternalDevice) {
          _externalDeviceStatus = '未连接蓝牙GPS设备';
        }
      } else {
        // 检查是否有GPS相关设备
        bool hasGPSDevice = false;
        List<String> gpsDeviceNames = [];

        for (var device in connectedDevices) {
          String deviceName = device.platformName.toLowerCase();
          // 检查设备名称是否包含GPS相关关键词
          if (deviceName.contains('gps') ||
              deviceName.contains('gnss') ||
              deviceName.contains('location') ||
              deviceName.contains('navigator')) {
            hasGPSDevice = true;
            gpsDeviceNames.add(device.platformName);
          }
        }

        if (hasGPSDevice) {
          _isUsingExternalDevice = true;
          _externalDeviceStatus =
              '已连接蓝牙GPS设备: ${gpsDeviceNames.join(", ")}';
        } else if (!_isUsingExternalDevice) {
          _externalDeviceStatus = '已连接蓝牙设备（非GPS）';
        }
      }
    } catch (e) {
      print('蓝牙检测出错: $e');
      if (!_isUsingExternalDevice) {
        _externalDeviceStatus = '蓝牙检测出错';
      }
    }
  }
}
