import 'package:test/test.dart';
import 'package:basic_timer_app/timer/domain/services/countdown_timer_service.dart';

void main() {
  group('CountdownTimerService', () {
    late CountdownTimerService service;

    setUp(() {
      service = CountdownTimerService();
    });

    test('counts down correctly', () async {
      service.start(Duration(seconds: 1), (values) {
        expect(values.inSeconds, lessThanOrEqualTo(1));
      });
      await Future.delayed(Duration(seconds: 2));
      expect(service.isRunning(), isFalse);
    });

    test('cancels correctly', () async {
      service.start(Duration(seconds: 10), (values) {});
      await Future.delayed(Duration(milliseconds: 500));
      service.cancel();
      expect(service.isRunning(), isFalse);
    });
  });
}