import 'package:flutter/services.dart';

abstract class Encryption {
  Future<String?> encrypt(String key, String value);

  Future<String?> decrypt(String key, String value);
}

class EncryptionChannel extends Encryption {
  static const encryptionChannel = MethodChannel('crypto_channel');
  static const ENCRYPT_METHOD = 'encrypt';
  static const DECRYPT_METHOD = 'decrypt';
  static const GEN_SECRET_KEY_METHOD = 'generate_secret_key'; // FIXME Remove me

  @override
  Future<String?> encrypt(String key, String value) async {
    try {
      final encryptedData =
          await encryptionChannel.invokeMethod(ENCRYPT_METHOD, {
        'key': key,
        'value': value,
      });
      return encryptedData;
    } on PlatformException catch (e) {
      print("Failed to encrypt: ${e.message}");
      return null;
    }
  }

  @override
  Future<String?> decrypt(String key, String value) async {
    try {
      final decryptedData =
          await encryptionChannel.invokeMethod(DECRYPT_METHOD, {
        'key': key,
        'value': value,
      });
      return decryptedData;
    } on PlatformException catch (e) {
      print("Failed to decrypt: ${e.message}");
      return null;
    }
  }
}
