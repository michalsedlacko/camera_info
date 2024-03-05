import 'package:flutter/material.dart';

import 'camera_info_platform_interface.dart';

class CameraInfo {
  Future<bool> isFlashAvailable() async {
    return CameraInfoPlatform.instance.isFlashAvailable();
  }

  Future<Size?> getMaxResolution() async {
    try {
      Size? maxResolution =
          await CameraInfoPlatform.instance.getMaxResolution();
      if (maxResolution != null) {
        return maxResolution;
      } else {
        throw FlutterError('max resolution is not available');
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> isManualFocusSupported() async {
    return await CameraInfoPlatform.instance.isManualFocusSupported();
  }
}
