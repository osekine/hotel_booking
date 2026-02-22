import 'package:domain/domain.dart';
import '../models/hotel_summary.dart';
import '../utils/date.dart';

class HotelSummaryService {
  final HotelRepository hotelRepo;
  final RoomRepository roomRepo;
  final BookingRepository bookingRepo;

  const HotelSummaryService({
    required this.hotelRepo,
    required this.roomRepo,
    required this.bookingRepo,
  });

  Future<List<HotelSummary>> loadSummaries({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final todayStart = startOfDayLocal(current);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    final hotels = await hotelRepo.getHotels();

    final summaries = await Future.wait(hotels.map((h) async {
      final rooms = await roomRepo.getRooms(hotelId: h.id);

      final roomStatuses = await Future.wait(rooms.map((r) async {
        final availability = await bookingRepo.checkAvailability(
          roomId: r.id,
          start: todayStart,
          end: tomorrowStart,
        );

        final details = await roomRepo.getRoomDetails(roomId: r.id);
        final nearest = _nearestBookingStart(details.bookings, current);

        return RoomStatus(
          room: r,
          isAvailableToday: availability.isAvailable,
          nearestBookingStart: nearest,
        );
      }));

      final freeToday = roomStatuses.where((s) => s.isAvailableToday).length;
      final busyToday = roomStatuses.length - freeToday;

      DateTime? hotelNearest;
      for (final rs in roomStatuses) {
        final n = rs.nearestBookingStart;
        if (n == null) continue;
        if (hotelNearest == null || n.isBefore(hotelNearest)) hotelNearest = n;
      }

      final sorted = [...roomStatuses]..sort((a, b) => a.room.number.compareTo(b.room.number));

      return HotelSummary(
        hotel: h,
        freeToday: freeToday,
        busyToday: busyToday,
        nearestBookingStart: hotelNearest,
        rooms: sorted,
      );
    }));

    summaries.sort((a, b) => a.hotel.name.compareTo(b.hotel.name));
    return summaries;
  }

  DateTime? _nearestBookingStart(List<Booking> bookings, DateTime now) {
    final active = bookings.where((b) => b.status == BookingStatus.active).toList();
    if (active.isEmpty) return null;

    final futureOrNow = active.where((b) => !b.startDate.isBefore(now)).toList();
    final source = futureOrNow.isNotEmpty ? futureOrNow : active;

    source.sort((a, b) => a.startDate.compareTo(b.startDate));
    return source.first.startDate;
  }
}
