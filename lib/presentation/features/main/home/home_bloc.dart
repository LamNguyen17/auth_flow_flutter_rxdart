import 'package:dartz/dartz.dart';

class HomeBloc {
  /// Input
  final Function0<void> dispose;

  /// Output

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
