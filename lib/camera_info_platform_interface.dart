import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'camera_info_method_channel.dart';

abstract class CameraInfoPlatform extends PlatformInterface {
  /// Constructs a CameraInfoPlatform.
  CameraInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static CameraInfoPlatform _instance = MethodChannelCameraInfo();

  /// The default instance of [CameraInfoPlatform] to use.
  ///
  /// Defaults to [MethodChannelCameraInfo].
  static CameraInfoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CameraInfoPlatform] when
  /// they register themselves.
  static set instance(CameraInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isFlashAvailable() {
    throw UnimplementedError('isFlashAvailable() has not been implemented.');
  }

  Future<Size?> getMaxResolution() {
    throw UnimplementedError('getMaxResolution() has not been implemented.');
  }

  Future<bool> isManualFocusSupported() {
    throw UnimplementedError('getMaxResolution() has not been implemented.');
  }
}
