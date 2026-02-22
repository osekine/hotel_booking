enum BookingStatus { active, canceled }

class Booking {
  final String id;
  final String roomId;
  final String guestName;
  final DateTime startDate;
  final DateTime endDate;
  final BookingStatus status;
  final DateTime? createdAt;
  final DateTime? canceledAt;

  const Booking({
    required this.id,
    required this.roomId,
    required this.guestName,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.createdAt,
    this.canceledAt,
  });
}
