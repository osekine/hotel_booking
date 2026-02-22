import 'package:domain/domain.dart';

import '../graphql/graphql_api.gen.dart';

BookingStatus _mapStatus(Enum$BookingStatus s) {
  return switch (s) {
    Enum$BookingStatus.ACTIVE => BookingStatus.active,
    Enum$BookingStatus.CANCELED => BookingStatus.canceled,
    _ => BookingStatus.active,
  };
}

Hotel mapHotel(Query$GetHotels$hotels dto) {
  return Hotel(id: dto.id, name: dto.name, city: dto.city);
}

Room mapRoom(Query$GetRooms$rooms dto) {
  return Room(
    id: dto.id,
    hotelId: dto.hotelId,
    number: dto.number,
    title: dto.title,
    capacity: dto.capacity,
    priceEur: dto.priceEur,
  );
}

RoomDetails mapRoomDetails(Query$GetRoom$room dto) {
  final room = Room(
    id: dto.id,
    hotelId: dto.hotelId,
    number: dto.number,
    title: dto.title,
    capacity: dto.capacity,
    priceEur: dto.priceEur,
  );

  final bookings = dto.bookings.map((b) {
    return Booking(
      id: b.id,
      roomId: dto.id,
      guestName: b.guestName,
      startDate: b.startDate,
      endDate: b.endDate,
      status: _mapStatus(b.status),
      createdAt: b.createdAt,
      canceledAt: b.canceledAt,
    );
  }).toList();

  return RoomDetails(room: room, bookings: bookings);
}

Availability mapAvailability(Query$GetAvailability$availability dto) {
  final conflicts = dto.conflicts.map((c) {
    return Booking(
      id: c.id,
      roomId: dto.roomId,
      guestName: c.guestName,
      startDate: c.startDate,
      endDate: c.endDate,
      status: _mapStatus(c.status),
    );
  }).toList();

  return Availability(
    roomId: dto.roomId,
    startDate: dto.startDate,
    endDate: dto.endDate,
    isAvailable: dto.isAvailable,
    conflicts: conflicts,
  );
}
