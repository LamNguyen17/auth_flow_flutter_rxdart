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
        const val INVALID_ARGUMENT = "invalid_argument"
        const val ENCRYPT_METHOD = "encrypt"
        const val DECRYPT_METHOD = "decrypt"
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
                ENCRYPT_METHOD -> {
                    val value = call.argument<String>("value")
                    val key = call.argument<String>("key")
                    if (key != null &&  value != null) {
                        activityScope.launch {
                            val encryptedData = withContext(Dispatchers.IO) {
                                aesHelper.encrypt(value, key)
                            }
                            result.success(encryptedData)
                        }
                    } else {
                        result.error(INVALID_ARGUMENT, "Data to encrypt is null", null)
                    }
                }

                DECRYPT_METHOD -> {
                    val value = call.argument<String>("value")
                    val key = call.argument<String>("key")
                    if (key != null && value != null) {
                        CoroutineScope(Dispatchers.Main).launch {
                            val decryptedData = withContext(Dispatchers.IO) {
                                aesHelper.decrypt(value, key)
                            }
                            result.success(decryptedData)
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
