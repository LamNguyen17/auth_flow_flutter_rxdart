import 'package:flutter/services.dart';
import 'package:auth_flow_flutter_rxdart/common/services/firebase_remote_config_service.dart';

abstract class Encryption {
  Future<String?> encrypt(String value);

  Future<String?> decrypt(String value);
}

class EncryptionChannel extends Encryption {
  static const encryptionChannel = MethodChannel('crypto_channel');
  static const ENCRYPT_METHOD = 'encrypt';
  static const DECRYPT_METHOD = 'decrypt';

  @override
  Future<String?> encrypt(String value) async {
    try {
      final encryptedData =
          await encryptionChannel.invokeMethod(ENCRYPT_METHOD, {
        'value': value,
        'key': FirebaseRemoteConfigService.getRemoteValue('secret_key'),
      });
      return encryptedData;
    } on PlatformException catch (e) {
      print("Failed to encrypt: ${e.message}");
      return null;
    }
  }

  @override
  Future<String?> decrypt(String value) async {
    try {
      final decryptedData =
          await encryptionChannel.invokeMethod(DECRYPT_METHOD, {
        'value': value,
        'key': FirebaseRemoteConfigService.getRemoteValue('secret_key'),
      });
      return decryptedData;
    } on PlatformException catch (e) {
      print("Failed to decrypt: ${e.message}");
      return null;
    }
  }
}
