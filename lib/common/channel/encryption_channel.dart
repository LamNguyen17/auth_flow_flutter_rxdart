import 'package:flutter/services.dart';

abstract class Encryption {
  Future<String?> generateSecretKey();

  Future<String?> encrypt(String data, String key);

  Future<String?> decrypt(String data, String key);
}

class EncryptionChannel extends Encryption {
  static const encryptionChannel = MethodChannel('encryption_channel');
  static const cryptoError = 'crypto_error';
  static const encryptMethod = 'encrypt';
  static const decryptMethod = 'decrypt';
  static const generateSecretKeyMethod = 'generate_secret_key';

  @override
  Future<String?> generateSecretKey() async {
    try {
      final key = await encryptionChannel.invokeMethod(generateSecretKeyMethod);
      return key;
    } on PlatformException catch (e) {
      print("Failed to generate secret key: ${e.message}");
      return null;
    }
  }

  @override
  Future<String?> encrypt(String data, String key) async {
    try {
      final encryptedData =
          await encryptionChannel.invokeMethod(encryptMethod, {
        'data': data,
        'key': key,
      });
      return encryptedData;
    } on PlatformException catch (e) {
      print("Failed to encrypt: ${e.message}");
      return null;
    }
  }

  @override
  Future<String?> decrypt(String data, String key) async {
    try {
      final decryptedData = await encryptionChannel.invokeMethod(decryptMethod, {
        'data': data,
        'key': key,
      });
      return decryptedData;
    } on PlatformException catch (e) {
      print("Failed to decrypt: ${e.message}");
      return null;
    }
  }
}
