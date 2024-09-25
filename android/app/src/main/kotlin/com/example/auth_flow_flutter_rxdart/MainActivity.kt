package com.example.auth_flow_flutter_rxdart

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class MainActivity : FlutterActivity() {
    private lateinit var encryptionChannel: MethodChannel
    private lateinit var aesHelper: AesHelper

    private companion object {
        const val CRYPTO_CHANNEL = "crypto_channel"
        const val CRYPTO_ERROR_CODE = "crypto_error"
        const val INVALID_ARGUMENT = "invalid_argument"
        const val KEY_GENERATION_ERROR = "key_generation_error"
        const val ENCRYPT_METHOD = "encrypt"
        const val DECRYPT_METHOD = "decrypt"
        const val GEN_SECRET_KEY_METHOD = "generate_secret_key"
    }

    // Used to create a custom CoroutineScope for managing coroutines.
    // Uses a SupervisorJob() to manage coroutines, so if one coroutine fails, it does not
    // affect the other coroutines launched within the same scope
    private val activityScope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        aesHelper = AesHelper()
        encryptionChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CRYPTO_CHANNEL)
        encryptionChannel.setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                GEN_SECRET_KEY_METHOD -> {
                    activityScope.launch {
                        try {
                            val key = aesHelper.generateSecretKey()
                            result.success(key)
                        } catch (e: Exception) {
                            result.error(KEY_GENERATION_ERROR, "Error during key generation", null)
                        }
                    }
                }

                ENCRYPT_METHOD -> {
                    val key = call.argument<String>("key")
                    val value = call.argument<String>("value")
                    if (key != null && value != null) {
                        activityScope.launch {
                            try {
                                val encryptedData = aesHelper.encrypt(key, value)
                                result.success(encryptedData)
                            } catch (e: Exception) {
                                result.error(CRYPTO_ERROR_CODE, "Error during encryption", null)
                            }
                        }
                    } else {
                        result.error(INVALID_ARGUMENT, "Data to encrypt is null", null)
                    }
                }

                DECRYPT_METHOD -> {
                    val key = call.argument<String>("key")
                    val value = call.argument<String>("value")
                    if (key != null && value != null) {
                        CoroutineScope(Dispatchers.Main).launch {
                            try {
                                val encryptedData = aesHelper.decrypt(key, value)
                                result.success(encryptedData)
                            } catch (e: Exception) {
                                result.error(CRYPTO_ERROR_CODE, "Error during encryption", null)
                            }
                        }
                    } else {
                        result.error(INVALID_ARGUMENT, "Data to encrypt is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        Log.d("Flutter", "cleanUpFlutterEngine :$flutterEngine $this")
        encryptionChannel.setMethodCallHandler(null)
        // Cancel the CoroutineScope to avoid memory leaks
        activityScope.cancel()
    }
}
