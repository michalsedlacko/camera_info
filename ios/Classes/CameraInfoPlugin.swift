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
    } else if call.method == "getMaxResolution" {
        if let resolution = getMaxResolution() {
            result(resolution)
        } else {
            result(nil)
        }
    } else if call.method == "isManualFocusSupported" {
      result(isManualFocusSupported())
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  private func getMaxResolution() -> [String: Any]? {
    
    guard let device = AVCaptureDevice.default(for: .video, position: .back) else {
        print("No video capture devices available")
        return nil
    }

   
    var maxResolution: CGSize = CGSize(width: 0, height: 0);
    for format in device.formats {
        let formatDescription = format.formatDescription
        let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
        let resolution = CGSize(width: CGFloat(dimensions.width), height: CGFloat(dimensions.height))
        if (resolution.width > maxResolution.width || resolution.height > maxResolution.height) {
          maxResolution = resolution
        }
        
    }
    let resolution: [String: Any] = [
      "width": maxResolution.width,
      "height": maxResolution.height
    ]
    return resolution
  }

  func isManualFocusSupported() -> Bool {
    // Check if the device has a camera available
    guard let device = AVCaptureDevice.default(for: .video, position: .back) else {
        print("No video capture devices available")
        return false
    }
    
    // Check if manual focus is supported
    let captureDevice = AVCaptureDevice.default(for: .video)
    
    if let supportsFocus = captureDevice?.isFocusModeSupported(.locked) {
        return supportsFocus
    } else {
        return false
    }
}
}
