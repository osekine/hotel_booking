sealed class Failure implements Exception {
  final String message;
  const Failure(this.message);
  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

class BookingConflictFailure extends Failure {
  final int conflictsCount;
  const BookingConflictFailure({required this.conflictsCount})
    : super('Booking conflicts with existing booking(s)');
}
