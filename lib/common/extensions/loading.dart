import 'package:rxdart/rxdart.dart';

extension Loading<E> on Stream<E> {
  Stream<E> setLoadingTo(
      bool isLoading, {
        required Sink<bool> onSink,
      }) =>
      doOnEach(
            (_) {
          onSink.add(isLoading);
        },
      );
}