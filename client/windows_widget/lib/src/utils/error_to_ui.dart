import 'package:domain/domain.dart';

String errorToUserMessage(Object error) {
  if (error is BookingConflictFailure) {
    return 'Конфликт бронирования. Конфликтов: ${error.conflictsCount}.';
  }
  if (error is NetworkFailure) {
    return 'Проблема с сетью. Проверь подключение и попробуй снова.';
  }
  if (error is Failure) {
    return error.message;
  }
  return error.toString();
}
