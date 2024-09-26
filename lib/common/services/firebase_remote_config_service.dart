import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  late FirebaseRemoteConfig _remoteConfig;

  FirebaseRemoteConfigService() {
    _remoteConfig = FirebaseRemoteConfig.instance;
  }

  // Initialize Firebase Remote Config with defaults and fetch the latest values
  Future<void> setupRemoteConfig() async {
    try {
      // Set default values for your Remote Config parameters
      await _remoteConfig.setDefaults(<String, dynamic>{
        'secret_key': '12345678900987654321123456789012',
        'api_key': '7d020902a2ff77454a1b04aaaa368d301',
      });

      // Optionally, configure the fetch intervals for development or production
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // Fetch and activate the latest remote config values
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Failed to fetch remote config: $e');
    }
  }

  // Get a Remote Config parameter value
  String getRemoteConfigValue(String key) {
    return _remoteConfig.getString(key);
  }

  static String getRemoteValue(String key) {
    return FirebaseRemoteConfigService().getRemoteConfigValue(key);
  }
}