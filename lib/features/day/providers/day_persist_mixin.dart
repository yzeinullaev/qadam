import 'package:flutter/foundation.dart';

/// Общая логика persist для Today / Day detail notifiers.
mixin DayPersistMixin {
  void persistDayAction(Future<void> Function() action) {
    action().catchError((Object e, StackTrace st) {
      debugPrint('Day persist error: $e\n$st');
    });
  }
}
