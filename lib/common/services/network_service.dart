import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkService {
  Future<bool> get isConnected;
}

class NetworkServiceImpl implements NetworkService {
  final InternetConnectionChecker _internetConnectionChecker;
  NetworkServiceImpl(this._internetConnectionChecker);

  @override
  Future<bool> get isConnected => _internetConnectionChecker.hasConnection;
}