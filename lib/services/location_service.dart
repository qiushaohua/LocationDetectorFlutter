import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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

      // 检测外部GPS设备
      await _checkExternalGPSDevices();

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

  Future<void> _checkExternalGPSDevices() async {
    try {
      // 在iOS和Android上检查蓝牙GPS设备

      // 请求蓝牙权限
      if (Platform.isAndroid) {
        var bluetoothStatus = await Permission.bluetooth.request();
        var bluetoothScanStatus = await Permission.bluetoothScan.request();
        var bluetoothConnectStatus = await Permission.bluetoothConnect.request();

        if (bluetoothStatus.isDenied ||
            bluetoothScanStatus.isDenied ||
            bluetoothConnectStatus.isDenied) {
          _externalDeviceStatus = '需要蓝牙权限以检测外部GPS设备';
          notifyListeners();
          return;
        }
      } else if (Platform.isIOS) {
        var bluetoothStatus = await Permission.bluetooth.request();
        if (bluetoothStatus.isDenied) {
          _externalDeviceStatus = '需要蓝牙权限以检测外部GPS设备';
          notifyListeners();
          return;
        }
      }

      // 检查蓝牙是否可用
      if (await FlutterBluePlus.isSupported == false) {
        _externalDeviceStatus = '设备不支持蓝牙';
        _isUsingExternalDevice = false;
        notifyListeners();
        return;
      }

      // 获取已连接的蓝牙设备
      List<BluetoothDevice> connectedDevices =
          await FlutterBluePlus.connectedDevices;

      if (connectedDevices.isEmpty) {
        _externalDeviceStatus = '未连接外部定位设备';
        _isUsingExternalDevice = false;
      } else {
        // 检查是否有GPS相关设备
        bool hasGPSDevice = false;
        for (var device in connectedDevices) {
          String deviceName = device.platformName.toLowerCase();
          // 检查设备名称是否包含GPS相关关键词
          if (deviceName.contains('gps') ||
              deviceName.contains('gnss') ||
              deviceName.contains('location') ||
              deviceName.contains('navigator')) {
            hasGPSDevice = true;
            break;
          }
        }

        if (hasGPSDevice) {
          _isUsingExternalDevice = true;
          _externalDeviceStatus = '已连接外部GPS设备';
        } else {
          _isUsingExternalDevice = false;
          _externalDeviceStatus = '已连接蓝牙设备（非GPS）';
        }
      }
    } catch (e) {
      print('检测外部设备时出错: $e');
      _externalDeviceStatus = '检测外部设备时出错';
      _isUsingExternalDevice = false;
    }

    notifyListeners();
  }
}
