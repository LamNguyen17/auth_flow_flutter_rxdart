package com.example.auth_flow_flutter_rxdart

import android.content.Context
import android.content.pm.PackageInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private companion object {
        const val CRYPTO_CHANNEL = "com.example.auth_flow_flutter_rxdart/crypto"
        const val CRYPTO_ERROR_CODE = "com.example.auth_flow_flutter_rxdart/crypto_error"
        const val ENCRYPT_METHOD = "encrypt"
        const val DECRYPT_METHOD = "decrypt"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVICE_INFO_CHANNEL).apply {
            setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                when (call.method) {
                    ENCRYPT_METHOD -> encrypt()
                    DECRYPT_METHOD -> decrypt()
                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun encrypt() {
        // Implement encryption logic here
    }

    private fun decrypt() {
        // Implement encryption logic here
    }
}
