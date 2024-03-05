import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:camera_info/camera_info.dart';
import 'package:camera_info/camera_info_platform_interface.dart';
import 'package:camera_info/camera_info_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCameraInfoPlatform
    with MockPlatformInterfaceMixin
    implements CameraInfoPlatform {
  @override
  Future<bool> isFlashAvailable() => Future.value(false);

  @override
  Future<Size?> getMaxResolution({bool video = false}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isManualFocusSupported() {
    throw UnimplementedError();
  }
}

void main() {
  final CameraInfoPlatform initialPlatform = CameraInfoPlatform.instance;

  test('$MethodChannelCameraInfo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCameraInfo>());
  });

  test('isFlashAvailable', () async {
    CameraInfo cameraInfoPlugin = CameraInfo();
    MockCameraInfoPlatform fakePlatform = MockCameraInfoPlatform();
    CameraInfoPlatform.instance = fakePlatform;

    expect(await cameraInfoPlugin.isFlashAvailable(), false);
  });
}
