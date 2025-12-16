package com.example.qibla_ar_finder

import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.qibla_ar_finder/ar"

    companion object {
        private const val TAG = "MainActivity"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startARView" -> {
                    val qiblaBearing = call.argument<Double>("qibla_bearing")?.toFloat() ?: 0f
                    Log.d(TAG, "Starting AR view with Qibla bearing: $qiblaBearing°")
                    startARCoreView(qiblaBearing)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    /**
     * Start ARCore-based AR view (native implementation)
     */
    private fun startARCoreView(qiblaBearing: Float) {
        val intent = Intent(this, ARCoreActivity::class.java)
        intent.putExtra("qibla_bearing", qiblaBearing)
        startActivity(intent)
    }
}
