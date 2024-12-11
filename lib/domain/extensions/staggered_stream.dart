import 'package:rxdart/rxdart.dart';

extension StaggeredStream<T> on Stream<T> {
  /// Combines the behavior of RxDart stream debounce and throttle
  Stream<T> stagger(final Duration duration) {
    return Rx.merge<T>([
      debounceTime(duration),
      throttleTime(duration),
    ]);
  }
}
