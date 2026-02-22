import 'package:domain/domain.dart';

class RoomStatus {
  final Room room;
  final bool isAvailableToday;
  final DateTime? nearestBookingStart; // min startDate среди ACTIVE
  const RoomStatus({
    required this.room,
    required this.isAvailableToday,
    required this.nearestBookingStart,
  });
}

class HotelSummary {
  final Hotel hotel;
  final int freeToday;
  final int busyToday;
  final DateTime? nearestBookingStart; // min по всем комнатам
  final List<RoomStatus> rooms;

  const HotelSummary({
    required this.hotel,
    required this.freeToday,
    required this.busyToday,
    required this.nearestBookingStart,
    required this.rooms,
  });
}
