import Flutter
import UIKit
import ExternalAccessory
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var locationResultCallback: FlutterResult?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

        // 创建ExternalGPS检测Channel
        let externalGPSChannel = FlutterMethodChannel(
            name: "com.example.location_detector/external_gps",
            binaryMessenger: controller.binaryMessenger
        )

        externalGPSChannel.setMethodCallHandler({ [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            if call.method == "checkExternalGPS" {
                self?.checkExternalGPSDevices(result: result)
            } else if call.method == "getLocationWithSource" {
                self?.getLocationWithSourceInfo(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - ExternalAccessory检测（与iOS原生版完全一致）
    private func checkExternalGPSDevices(result: @escaping FlutterResult) {
        let connectedAccessories = EAAccessoryManager.shared().connectedAccessories

        // 检查GPS相关设备（与iOS原生版LocationManager.swift:60-67完全一致）
        let gpsAccessories = connectedAccessories.filter { accessory in
            let protocols = accessory.protocolStrings
            return protocols.contains { protocol in
                protocol.lowercased().contains("gps") ||
                protocol.lowercased().contains("nmea") ||
                protocol.lowercased().contains("location")
            }
        }

        var deviceList: [[String: String]] = []
        for accessory in gpsAccessories {
            let deviceInfo: [String: String] = [
                "name": accessory.name,
                "manufacturer": accessory.manufacturer,
                "modelNumber": accessory.modelNumber,
                "serialNumber": accessory.serialNumber,
                "firmwareRevision": accessory.firmwareRevision,
                "hardwareRevision": accessory.hardwareRevision,
                "protocols": accessory.protocolStrings.joined(separator: ", ")
            ]
            deviceList.append(deviceInfo)

            // 打印设备信息（与iOS原生版LocationManager.swift:74-76一致）
            print("外部GPS设备: \(accessory.name), 制造商: \(accessory.manufacturer)")
        }

        let response: [String: Any] = [
            "hasExternalGPS": !gpsAccessories.isEmpty,
            "deviceCount": gpsAccessories.count,
            "devices": deviceList,
            "totalAccessories": connectedAccessories.count,
            "hasOtherAccessories": !connectedAccessories.isEmpty && gpsAccessories.isEmpty
        ]

        result(response)
    }

    // MARK: - 获取位置并检测来源（iOS 15+特性）
    private func getLocationWithSourceInfo(result: @escaping FlutterResult) {
        locationResultCallback = result

        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        }

        // 请求权限
        let status = locationManager?.authorizationStatus ?? .notDetermined
        if status == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        } else {
            result(FlutterError(
                code: "PERMISSION_DENIED",
                message: "定位权限被拒绝",
                details: nil
            ))
            locationResultCallback = nil
        }
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // 停止更新以节省电量（与iOS原生版LocationManager.swift:120一致）
        manager.stopUpdatingLocation()

        var locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "accuracy": location.horizontalAccuracy,
            "altitude": location.altitude,
            "speed": location.speed,
            "timestamp": location.timestamp.timeIntervalSince1970
        ]

        // iOS 15+ 检查位置来源信息（与iOS原生版LocationManager.swift:100-111完全一致）
        if #available(iOS 15.0, *) {
            if let sourceInfo = location.sourceInformation {
                print("位置来源信息: \(sourceInfo)")

                locationData["hasSourceInfo"] = true
                locationData["isProducedByAccessory"] = sourceInfo.isProducedByAccessory
                locationData["isSimulatedBySoftware"] = sourceInfo.isSimulatedBySoftware

                // 检查是否为外部附件提供的位置
                if sourceInfo.isProducedByAccessory {
                    print("✓ 位置来自外部附件")
                }
            } else {
                locationData["hasSourceInfo"] = false
            }
        } else {
            locationData["hasSourceInfo"] = false
            locationData["iosVersionTooOld"] = true
        }

        // 检查高精度定位（与iOS原生版LocationManager.swift:114-117一致）
        if location.horizontalAccuracy < 5.0 {
            print("检测到高精度定位（可能使用外部GPS）")
            locationData["isHighAccuracy"] = true
        } else {
            locationData["isHighAccuracy"] = false
        }

        if let callback = locationResultCallback {
            callback(locationData)
            locationResultCallback = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let callback = locationResultCallback {
            callback(FlutterError(
                code: "LOCATION_ERROR",
                message: "定位失败: \(error.localizedDescription)",
                details: nil
            ))
            locationResultCallback = nil
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        } else if status == .denied || status == .restricted {
            if let callback = locationResultCallback {
                callback(FlutterError(
                    code: "PERMISSION_DENIED",
                    message: "定位权限被拒绝",
                    details: nil
                ))
                locationResultCallback = nil
            }
        }
    }
}
