import 'package:auth_flow_flutter_rxdart/common/channel/encryption_channel.dart';
import 'package:auth_flow_flutter_rxdart/common/services/firebase_remote_config_service.dart';

class AppConfig {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static Future<String?> apiKey() async {
    final encryptionChannel = EncryptionChannel();
    return await encryptionChannel
        .decrypt(FirebaseRemoteConfigService.getRemoteValue('api_key'));
  }
}
