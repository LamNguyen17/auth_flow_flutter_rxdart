import 'package:auth_flow_flutter_rxdart/common/channel/encryption_channel.dart';
import 'package:dartz/dartz.dart';

import 'package:auth_flow_flutter_rxdart/di/injection.dart';
import 'package:auth_flow_flutter_rxdart/presentation/features/main/movie/movie_bloc.dart';
import 'package:flutter/services.dart';

class HomeBloc {
  /// Input
  final Function0<void> dispose;

  /// Output

  void initial() {
    encrypt('HELLO','123456');
    decrypt('HELLO');
  }

  void encrypt(String key, String value) async {
    try {
      final encryptionChannel = EncryptionChannel();
      final result = await encryptionChannel.encrypt('HELLO','123456');
      print('Result_from_Native_encrypt: $result');
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  void decrypt(String key) async {
    try {
      final encryptionChannel = EncryptionChannel();
      final result = await encryptionChannel.decrypt('HELLO', '1');
      print('Result_from_Native_decrypt: $result');
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  void close() {
    dispose();
  }

  factory HomeBloc() {

    return HomeBloc._(
      dispose: () {},
    );
  }

  HomeBloc._({
    required this.dispose,
  });
}
