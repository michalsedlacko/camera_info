import 'camera_info_platform_interface.dart';

class CameraInfo {
  Future<bool> isFlashAvailable() async {
    return CameraInfoPlatform.instance.isFlashAvailable();
  }
}
