import 'package:domain/domain.dart';

String errorToUserMessage(Object error) {
  if (error is BookingConflictFailure) {
    final n = error.conflictsCount;
    return 'Даты заняты. Найдено конфликтов: $n.';
  }
  if (error is NetworkFailure) {
    return 'Проблема с сетью. Проверь подключение и попробуй снова.';
  }
  if (error is Failure) {
    return error.message;
  }
  return error.toString();
}
