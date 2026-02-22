import 'package:flutter_test/flutter_test.dart';
import 'package:domain/domain.dart';
import 'package:windows_widget/src/services/hotel_summary_service.dart';

class FakeHotelRepo implements HotelRepository {
  final List<Hotel> hotels;
  FakeHotelRepo(this.hotels);

  @override
  Future<List<Hotel>> getHotels() async => hotels;
}

class FakeRoomRepo implements RoomRepository {
  final Map<String, List<Room>> roomsByHotel;
  final Map<String, RoomDetails> detailsByRoomId;

  FakeRoomRepo({required this.roomsByHotel, required this.detailsByRoomId});

  @override
  Future<List<Room>> getRooms({required String hotelId}) async {
    return roomsByHotel[hotelId] ?? const [];
  }

  @override
  Future<RoomDetails> getRoomDetails({required String roomId}) async {
    final d = detailsByRoomId[roomId];
    if (d == null) throw StateError('No details for roomId=$roomId');
    return d;
  }
}

class FakeBookingRepo implements BookingRepository {
  final Map<String, Availability> availabilityByRoomId;
  FakeBookingRepo(this.availabilityByRoomId);

  @override
  Future<Availability> checkAvailability({
    required String roomId,
    required DateTime start,
    required DateTime end,
  }) async {
    final a = availabilityByRoomId[roomId];
    if (a == null) throw StateError('No availability for roomId=$roomId');
    return a;
  }

  @override
  Future<Booking> createBooking({
    required String roomId,
    required String guestName,
    required DateTime start,
    required DateTime end,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> cancelBooking({required String bookingId}) {
    throw UnimplementedError();
  }
}

void main() {
  test('computes free/busy today and nearest booking per hotel', () async {
    final hotel = Hotel(id: 'h1', name: 'Hotel A', city: 'AMS');

    final room1 = Room(id: 'r1', hotelId: 'h1', number: '101', title: null, capacity: 2, priceEur: 100);
    final room2 = Room(id: 'r2', hotelId: 'h1', number: '102', title: null, capacity: 2, priceEur: 120);

    final now = DateTime(2026, 2, 22, 10, 0);

    final service = HotelSummaryService(
      hotelRepo: FakeHotelRepo([hotel]),
      roomRepo: FakeRoomRepo(
        roomsByHotel: {'h1': [room1, room2]},
        detailsByRoomId: {
          'r1': RoomDetails(room: room1, bookings: [
            Booking(
              id: 'b1',
              roomId: 'r1',
              guestName: 'X',
              startDate: DateTime(2026, 2, 25),
              endDate: DateTime(2026, 2, 26),
              status: BookingStatus.active,
            ),
          ]),
          'r2': RoomDetails(room: room2, bookings: [
            Booking(
              id: 'b2',
              roomId: 'r2',
              guestName: 'Y',
              startDate: DateTime(2026, 2, 23),
              endDate: DateTime(2026, 2, 24),
              status: BookingStatus.active,
            ),
          ]),
        },
      ),
      bookingRepo: FakeBookingRepo({
        'r1': Availability(
          roomId: 'r1',
          startDate: DateTime(2026, 2, 22),
          endDate: DateTime(2026, 2, 23),
          isAvailable: true,
          conflicts: const [],
        ),
        'r2': Availability(
          roomId: 'r2',
          startDate: DateTime(2026, 2, 22),
          endDate: DateTime(2026, 2, 23),
          isAvailable: false,
          conflicts: const [],
        ),
      }),
    );

    final summaries = await service.loadSummaries(now: now);
    expect(summaries, hasLength(1));

    final s = summaries.first;
    expect(s.freeToday, 1);
    expect(s.busyToday, 1);
    expect(s.nearestBookingStart, DateTime(2026, 2, 23));
  });

  test('fail-fast if availability missing for a room', () async {
    final hotel = Hotel(id: 'h1', name: 'Hotel A', city: 'AMS');
    final room = Room(id: 'r1', hotelId: 'h1', number: '101', title: null, capacity: 2, priceEur: 100);

    final service = HotelSummaryService(
      hotelRepo: FakeHotelRepo([hotel]),
      roomRepo: FakeRoomRepo(
        roomsByHotel: {'h1': [room]},
        detailsByRoomId: {
          'r1': RoomDetails(room: room, bookings: const []),
        },
      ),
      bookingRepo: FakeBookingRepo({}),
    );

    await expectLater(
      () => service.loadSummaries(now: DateTime(2026, 2, 22)),
      throwsA(isA<StateError>()),
    );
  });
}
