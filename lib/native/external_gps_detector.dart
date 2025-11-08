import 'dart:io';
import 'package:flutter/services.dart';

class ExternalGPSDetector {
  static const MethodChannel _channel =
      MethodChannel('com.example.location_detector/external_gps');

  /// 检查外部GPS设备（仅iOS支持ExternalAccessory检测）
  /// 完全对应iOS原生版LocationManager.swift的checkExternalAccessories()方法
  /// 返回格式: {
  ///   "hasExternalGPS": bool,
  ///   "deviceCount": int,
  ///   "devices": [{"name": "...", "manufacturer": "...", "protocols": "..."}],
  ///   "totalAccessories": int,
  ///   "hasOtherAccessories": bool
  /// }
  static Future<Map<String, dynamic>?> checkExternalGPS() async {
    if (!Platform.isIOS) {
      return {
        'hasExternalGPS': false,
        'deviceCount': 0,
        'devices': [],
        'totalAccessories': 0,
        'hasOtherAccessories': false,
        'message': 'ExternalAccessory仅iOS支持'
      };
    }

    try {
      final Map<dynamic, dynamic>? result =
          await _channel.invokeMethod('checkExternalGPS');

      if (result != null) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } on PlatformException catch (e) {
      print('检测外部GPS设备失败: ${e.message}');
      return null;
    }
  }

  /// 获取位置并检查来源（iOS 15+特性 - sourceInformation）
  /// 完全对应iOS原生版LocationManager.swift的didUpdateLocations方法
  /// 返回格式: {
  ///   "latitude": double,
  ///   "longitude": double,
  ///   "accuracy": double,
  ///   "altitude": double,
  ///   "speed": double,
  ///   "timestamp": double,
  ///   "hasSourceInfo": bool,
  ///   "isProducedByAccessory": bool (iOS 15+),
  ///   "isSimulatedBySoftware": bool (iOS 15+),
  ///   "isHighAccuracy": bool
  /// }
  static Future<Map<String, dynamic>?> getLocationWithSource() async {
    if (!Platform.isIOS) {
      return {
        'error': true,
        'message': 'iOS专属特性'
      };
    }

    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod(
        'getLocationWithSource',
      );

      if (result != null) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } on PlatformException catch (e) {
      print('获取位置来源失败: ${e.message}');
      return {
        'error': true,
        'message': e.message ?? '未知错误',
        'code': e.code
      };
    }
  }
}
