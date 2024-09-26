package com.example.auth_flow_flutter_rxdart

import android.util.Base64
import java.security.SecureRandom
import javax.crypto.*
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

class AesHelper {
    private companion object {
        const val ALGORITHM = "AES"
        const val TRANSFORMATION = "AES/CBC/PKCS5PADDING"
        private const val IV_LENGTH = 16   // 16 bytes for AES block size
    }

    private fun generateSecretKey(secretKey: String): SecretKeySpec {
        return SecretKeySpec(secretKey.toByteArray(), ALGORITHM)
    }

    private fun generateIvKey(ivKey: String): IvParameterSpec {
        return IvParameterSpec(ivKey.toByteArray())
    }

    fun encrypt(value: String, privateKey: String, ivKey: String): String {
        val ivSpec = generateIvKey(ivKey)
        val secretKey = generateSecretKey(privateKey)
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivSpec)
        val encryptedBytes = cipher.doFinal(value.toByteArray())
//        val ivAndEncryptedData = ByteArray(IV_LENGTH) + encryptedBytes
        return Base64.encodeToString(encryptedBytes, Base64.DEFAULT)
    }

    fun decrypt(value: String, privateKey: String, ivKey: String): String {
        val decodedBytes = Base64.decode(value, Base64.DEFAULT)
        val ivSpec = generateIvKey(ivKey)
        val encryptedBytes = decodedBytes.copyOfRange(IV_LENGTH, decodedBytes.size)
        val secretKey = generateSecretKey(privateKey)
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.DECRYPT_MODE, secretKey, ivSpec)
        val decryptedBytes = cipher.doFinal(encryptedBytes)
        return String(decryptedBytes, Charsets.UTF_8)
    }

}