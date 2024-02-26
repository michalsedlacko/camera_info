import Flutter
import UIKit

public class CameraInfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "camera_info", binaryMessenger: registrar.messenger())
    let instance = CameraInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "isFlashAvailable" {
      let hasFlash = AVCaptureDevice.default(for: .video)?.hasTorch ?? false
            result(hasFlash)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
