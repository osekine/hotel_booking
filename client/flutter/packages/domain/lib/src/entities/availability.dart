import 'booking.dart';

class Availability {
  final String roomId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAvailable;
  final List<Booking> conflicts;

  const Availability({
    required this.roomId,
    required this.startDate,
    required this.endDate,
    required this.isAvailable,
    required this.conflicts,
  });
}
