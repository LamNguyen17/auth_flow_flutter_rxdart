import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

extension DebugStream<T> on Stream<T> {
  Stream<T> debug() {
    return doOnData((data) => debugPrint('===>>> Data: $data'))
        .doOnError((error, stackTrace) => debugPrint('===>>> Error: $error'))
        .doOnDone(() => {});
  }
}
