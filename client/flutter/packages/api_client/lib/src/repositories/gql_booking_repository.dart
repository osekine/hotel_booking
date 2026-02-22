import 'package:domain/domain.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/graphql_api.gen.dart';
import '../mappers/dto_mapper.dart';
import '../mappers/error_mapper.dart';

class GqlBookingRepository implements BookingRepository {
  final GraphQLClient _client;
  GqlBookingRepository(this._client);

  @override
  Future<Availability> checkAvailability({
    required String roomId,
    required DateTime start,
    required DateTime end,
  }) async {
    final res = await _client.query$GetAvailability(
      Options$Query$GetAvailability(
        variables: Variables$Query$GetAvailability(
          roomId: roomId,
          startDate: start,
          endDate: end,
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (res.hasException) throw mapOperationException(res.exception!);
    return mapAvailability(res.parsedData!.availability);
  }

  @override
  Future<Booking> createBooking({
    required String roomId,
    required String guestName,
    required DateTime start,
    required DateTime end,
  }) async {
    final res = await _client.mutate$CreateBooking(
      Options$Mutation$CreateBooking(
        variables: Variables$Mutation$CreateBooking(
          roomId: roomId,
          guestName: guestName,
          startDate: start,
          endDate: end,
        ),
      ),
    );
    if (res.hasException) throw mapOperationException(res.exception!);

    final b = res.parsedData!.createBooking;
    return Booking(
      id: b.id,
      roomId: b.roomId,
      guestName: b.guestName,
      startDate: b.startDate,
      endDate: b.endDate,
      status: BookingStatus.active,
      createdAt: b.createdAt,
    );
  }

  @override
  Future<void> cancelBooking({required String bookingId}) async {
    final res = await _client.mutate$CancelBooking(
      Options$Mutation$CancelBooking(
        variables: Variables$Mutation$CancelBooking(bookingId: bookingId),
      ),
    );
    if (res.hasException) throw mapOperationException(res.exception!);
  }
}
