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
}
