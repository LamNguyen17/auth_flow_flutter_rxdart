package com.example.auth_flow_flutter_rxdart

import android.util.Base64
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

object AesHelper {
    private const val KEYSIZE = 256
    private const val ALGORITHM = "AES"
    private const val TRANSFORMATION = "AES/CBC/PKCS7PADDING"

    fun generateSecretKey(): SecretKey {
        val keyGenerator = KeyGenerator.getInstance(ALGORITHM)
        keyGenerator.init(KEYSIZE)
        return keyGenerator.generateKey()
    }

    fun encrypt(
        textToEncrypt: String,
        secretKey: SecretKey,
        iv: IvParameterSpec
    ): String {
        val plainText = textToEncrypt.toByteArray()

        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, iv)

        val encrypt = cipher.doFinal(plainText)
        return Base64.encodeToString(encrypt, Base64.DEFAULT)
    }
}