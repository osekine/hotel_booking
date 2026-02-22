import '../entities/room.dart';
import '../entities/booking.dart';

class RoomDetails {
  final Room room;
  final List<Booking> bookings; // ACTIVE only
  const RoomDetails({required this.room, required this.bookings});
}

abstract interface class RoomRepository {
  Future<List<Room>> getRooms({required String hotelId});
  Future<RoomDetails> getRoomDetails({required String roomId});
}
