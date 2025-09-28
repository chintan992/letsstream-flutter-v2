package com.chintan992.lets_stream

import android.app.PictureInPictureParams
import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.letsstream.pip/pip_channel"
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            android.util.Log.d("MainActivity", "Method channel called: ${call.method}")
            when (call.method) {
                "enterPipMode" -> {
                    android.util.Log.d("MainActivity", "Attempting to enter PIP mode...")
                    val aspectRatio = call.argument<Double>("aspectRatio") ?: (16.0 / 9.0)
                    android.util.Log.d("MainActivity", "Aspect ratio: $aspectRatio")
                    val success = enterPictureInPictureMode(aspectRatio)
                    android.util.Log.d("MainActivity", "PIP result: $success")
                    result.success(success)
                }
                else -> {
                    android.util.Log.d("MainActivity", "Unknown method: ${call.method}")
                    result.notImplemented()
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun enterPictureInPictureMode(aspectRatio: Double): Boolean {
        android.util.Log.d("MainActivity", "enterPictureInPictureMode called with aspectRatio: $aspectRatio")
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                android.util.Log.d("MainActivity", "Android version supports PIP")
                val rational = Rational((aspectRatio * 100).toInt(), 100)
                android.util.Log.d("MainActivity", "Created Rational: $rational")
                val params = PictureInPictureParams.Builder()
                    .setAspectRatio(rational)
                    .build()
                
                android.util.Log.d("MainActivity", "Created PIP params, calling enterPictureInPictureMode...")
                val result = enterPictureInPictureMode(params)
                android.util.Log.d("MainActivity", "enterPictureInPictureMode returned: $result")
                result
            } else {
                android.util.Log.d("MainActivity", "Android version does not support PIP")
                false
            }
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Exception in enterPictureInPictureMode: ${e.message}")
            e.printStackTrace()
            false
        }
    }

    override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean, newConfig: Configuration?) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        
        android.util.Log.d("MainActivity", "PIP mode changed: $isInPictureInPictureMode")
        
        // Notify Flutter about PIP mode changes
        try {
            channel.invokeMethod("onPipModeChanged", isInPictureInPictureMode)
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Failed to notify Flutter about PIP mode change: ${e.message}")
        }
    }
}
