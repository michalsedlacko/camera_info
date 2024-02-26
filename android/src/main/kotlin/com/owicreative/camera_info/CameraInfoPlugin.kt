package com.owicreative.camera_info

import android.content.Context
import android.content.pm.PackageManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Build
import android.util.Size
import androidx.annotation.RequiresApi

/** CameraInfoPlugin */
class CameraInfoPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var context: Context
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "camera_info")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "isFlashAvailable") {
      val hasFlash: Boolean =
        context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
      result.success(hasFlash)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  fun getSupportedResolutions(): Size? {
    var maxResolution:Size = Size(0,0)

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      val manager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
      try {
        val cameraId = manager.cameraIdList[0]
        val characteristics = manager.getCameraCharacteristics(cameraId)
        val map = characteristics.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
        map?.getOutputSizes(android.media.MediaRecorder::class.java)?.forEach { size ->
          if(maxResolution.width > size.width || maxResolution.height > size.height ) {
            maxResolution = size;
          }
        }
      } catch (e: Exception) {
        e.printStackTrace()
      }
    }
    return maxResolution
  }
}
