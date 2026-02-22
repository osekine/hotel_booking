import '../entities/availability.dart';
import '../entities/booking.dart';

abstract interface class BookingRepository {
  Future<Availability> checkAvailability({
    required String roomId,
    required DateTime start,
    required DateTime end,
  });

  Future<Booking> createBooking({
    required String roomId,
    required String guestName,
    required DateTime start,
    required DateTime end,
  });

  Future<void> cancelBooking({required String bookingId});
}
