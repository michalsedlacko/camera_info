package com.owicreative.camera_info

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.media.MediaCodecInfo
import android.media.MediaCodecList
import android.os.Build
import android.util.Size
import androidx.annotation.RequiresApi
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** CameraInfoPlugin */
class CameraInfoPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var context: Context
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "camera_info")
    channel.setMethodCallHandler(this)
  }

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "isFlashAvailable" -> {
          val hasFlash: Boolean =
            context.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
          result.success(hasFlash)
        }
        "getMaxResolution" -> {
          result.success(getMaxResolution())
        }
        "isManualFocusSupported" -> {
          result.success(isManualFocusSupported())
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
//  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
//  fun getMaxResolutionVideo(): Map<String, Any>? {
//    val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
//    var maxResolution: Size? = null
//
//    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//      try {
//        val cameraIdList = cameraManager.cameraIdList
//        val characteristics = cameraManager.getCameraCharacteristics(cameraIdList[0])
//        val configs = characteristics.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
//        val largestSize = configs?.getOutputSizes(android.media.MediaRecorder::class.java)?.maxByOrNull { it.width * it.height }
//        if (largestSize != null) {
//          return mapOf("width" to largestSize.width,"height" to  largestSize.height)
//        }
//        return null
//      } catch (e: Exception) {
//        e.printStackTrace()
//        return null
//      }
//    }
//    return null
//  }
  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  fun getMaxResolution(): Map<String, Any>? {
    val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      try {
        val cameraIdList = cameraManager.cameraIdList
        val characteristics = cameraManager.getCameraCharacteristics(cameraIdList[0])
        val map = characteristics.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
        val choices = map?.getOutputSizes(android.media.MediaRecorder::class.java)
//        map?.getOutputSizes(android.media.MediaRecorder::class.java)?.forEach {
//          Log.d("CameraInfoPlugin","width: "+ it.width.toString() + " height: " + it.height.toString())
//        }

        val largestSize = map?.getOutputSizes(android.media.MediaRecorder::class.java)?.maxByOrNull { it.width * it.height }
        if (largestSize != null) {
          return mapOf("width" to largestSize.width,"height" to  largestSize.height)
        }
        return null
      } catch (e: Exception) {
        e.printStackTrace()
        return null
      }
    }
    return  null
  }

  fun isManualFocusSupported(): Boolean {
    val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager

    try {
      val cameraIdList = cameraManager.cameraIdList
      val characteristics = cameraManager.getCameraCharacteristics(cameraIdList[0])

      val capabilities = characteristics.get(CameraCharacteristics.CONTROL_AF_AVAILABLE_MODES)

      if (capabilities == null) {
        // Auto-focus mode is not supported
        return false
      } else {
        for (mode in capabilities) {
          if (mode == CameraCharacteristics.CONTROL_AF_MODE_OFF) {
            // Manual focus is supported
            return true
          }
        }
        // Manual focus is not supported
        return false
      }
    } catch (e: CameraAccessException) {
      e.printStackTrace()
      // Handle exception
      return false
    }
  }
}
