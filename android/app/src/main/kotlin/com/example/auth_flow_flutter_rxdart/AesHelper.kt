package com.example.auth_flow_flutter_rxdart

import android.util.Base64
import kotlinx.coroutines.*
import javax.crypto.*
import javax.crypto.spec.SecretKeySpec

class AesHelper {
    private companion object {
        const val KEYSIZE = 256
        const val ALGORITHM = "AES"
        const val TRANSFORMATION = "AES/CBC/PKCS7PADDING"
    }

    fun generateSecretKey(): SecretKey {
        val keyGenerator = KeyGenerator.getInstance(ALGORITHM)
        keyGenerator.init(KEYSIZE)
        return keyGenerator.generateKey()
    }

    // Function to encrypt data
    suspend fun encrypt(key: String, value: String): String {
        return withContext(Dispatchers.IO) {
            val secretKey = SecretKeySpec(key.toByteArray(Charsets.UTF_8), "AES")
            val cipher = Cipher.getInstance(TRANSFORMATION)
            cipher.init(Cipher.ENCRYPT_MODE, secretKey)
            val encryptedBytes = cipher.doFinal(value.toByteArray())
            Base64.encodeToString(encryptedBytes, Base64.DEFAULT)
        }
    }

    // Function to decrypt data
    suspend fun decrypt(key: String, value: String): String {
        return withContext(Dispatchers.IO) {
            val secretKey = SecretKeySpec(key.toByteArray(Charsets.UTF_8), "AES")
            val cipher = Cipher.getInstance(TRANSFORMATION)
            cipher.init(Cipher.DECRYPT_MODE, secretKey)
            val decodedBytes = Base64.decode(value, Base64.DEFAULT)
            val decryptedBytes = cipher.doFinal(decodedBytes)
            String(decryptedBytes)
        }
    }

}