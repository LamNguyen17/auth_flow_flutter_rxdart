package com.example.auth_flow_flutter_rxdart

import android.util.Base64
import java.security.SecureRandom
import javax.crypto.*
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

class AesHelper {
    private companion object {
        const val ALGORITHM = "AES"
        const val TRANSFORMATION = "AES/CBC/PKCS7PADDING"
        private const val IV_LENGTH = 16   // 16 bytes for AES block size
    }

    private fun generateSecretKey(secretKey: String): SecretKey {
        return SecretKeySpec(secretKey.toByteArray(), ALGORITHM)
    }

    fun encrypt(value: String, key: String): String {
        val iv = ByteArray(IV_LENGTH)
        SecureRandom().nextBytes(iv)
        val ivSpec = IvParameterSpec(iv)
        val cipher = Cipher.getInstance(TRANSFORMATION)
        val secretKey = generateSecretKey(key)
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivSpec)
        val encryptedBytes = cipher.doFinal(value.toByteArray())
        val ivAndEncryptedData = iv + encryptedBytes
        return Base64.encodeToString(ivAndEncryptedData, Base64.DEFAULT)
    }

    fun decrypt(value: String, key: String): String {
        val decodedBytes = Base64.decode(value, Base64.DEFAULT)
        val iv = decodedBytes.copyOfRange(0, IV_LENGTH)
        val ivSpec = IvParameterSpec(iv)
        val encryptedBytes = decodedBytes.copyOfRange(IV_LENGTH, decodedBytes.size)
        val cipher = Cipher.getInstance(TRANSFORMATION)
        val secretKey = generateSecretKey(key)
        cipher.init(Cipher.DECRYPT_MODE, secretKey, ivSpec)
        val decryptedBytes = cipher.doFinal(encryptedBytes)
        return String(decryptedBytes, Charsets.UTF_8)
    }

}