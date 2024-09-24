package com.example.auth_flow_flutter_rxdart

import android.content.Context
import android.content.pm.PackageInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.crypto.KeyGenerator
import android.util.Base64
import javax.crypto.SecretKey
import android.os.Bundle
import java.security.Key
import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec

class MainActivity : FlutterActivity() {
    private companion object {
        const val CRYPTO_CHANNEL = "encryption_channel"
        const val CRYPTO_ERROR_CODE = "crypto_error"
        const val ENCRYPT_METHOD = "encrypt"
        const val DECRYPT_METHOD = "decrypt"
        const val GEN_SECRET_KEY_METHOD = "generate_secret_key"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CRYPTO_CHANNEL).apply {
            setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                when (call.method) {
                    GEN_SECRET_KEY_METHOD -> result.success(generateSecretKey())
                    ENCRYPT_METHOD -> {
                        val data = call.argument<String>("data")
                        val key = call.argument<String>("key")
                        if (data != null && key != null) {
                            result.success(encrypt(data, key))
                        } else {
                            result.error("ERROR", "Invalid arguments", null)
                        }
                    }
                    DECRYPT_METHOD -> decrypt(call, result)
                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun generateSecretKey(): String? {
        return try {
            val keyGen: KeyGenerator = KeyGenerator.getInstance("AES")
            keyGen.init(256)
            val secretKey: SecretKey = keyGen.generateKey()
            val encodedKey = Base64.encodeToString(secretKey.encoded, Base64.DEFAULT)
            encodedKey
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun encrypt(data: String, key: String) {

    }

    private fun decrypt(call: MethodCall, result: MethodChannel.Result) {
        // Implement encryption logic here
    }
}
