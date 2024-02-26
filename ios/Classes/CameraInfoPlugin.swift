import Flutter
import UIKit
import AVFoundation

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

  private func getSupportedResolutions() -> CGSize? {
    guard let device = AVCaptureDevice.default(for: .video) else {
        print("No video capture devices available")
        return nil
    }

    var maxResoulution: CGSize = CGSize.zero
    for format in device.formats {
        let formatDescription = format.formatDescription
        let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
        let resolution = CGSize(width: CGFloat(dimensions.width), height: CGFloat(dimensions.height))
        if resolution.width > maxResolution.width || resolution.height > maxResolution.height {
          maxResolution = resolution
        }
        
    }
    return maxResoulution
  }
}
