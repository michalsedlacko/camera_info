import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camera_info_platform_interface.dart';

/// An implementation of [CameraInfoPlatform] that uses method channels.
class MethodChannelCameraInfo extends CameraInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camera_info');

  @override
  Future<bool> isFlashAvailable() async {
    final hasFlash = await methodChannel.invokeMethod<bool>('isFlashAvailable');
    return hasFlash ?? false;
  }

  @override
  Future<Size?> getMaxResolution() async {
    final result = await methodChannel.invokeMethod('getMaxResolution');
    if (result is Map) {
      if (result['width'] <= 0) {
        return null;
      }
      return Size(double.parse(result['width'].toString()),
          double.parse(result['height'].toString()));
    } else {
      return null;
    }
  }

  @override
  Future<bool> isManualFocusSupported() async {
    final hasManualFocus =
        await methodChannel.invokeMethod<bool>('isManualFocusSupported');
    return hasManualFocus ?? false;
  }
}
