import 'package:api_client/src/graphql/graphql_api.gen.dart';
import 'package:domain/domain.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../mappers/dto_mapper.dart';
import '../mappers/error_mapper.dart';

class GqlRoomRepository implements RoomRepository {
  final GraphQLClient _client;
  GqlRoomRepository(this._client);

  @override
  Future<List<Room>> getRooms({required String hotelId}) async {
    final res = await _client.query$GetRooms(
      Options$Query$GetRooms(
        variables: Variables$Query$GetRooms(hotelId: hotelId),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (res.hasException) throw mapOperationException(res.exception!);
    return res.parsedData!.rooms.map(mapRoom).toList();
  }

  @override
  Future<RoomDetails> getRoomDetails({required String roomId}) async {
    final res = await _client.query$GetRoom(
      Options$Query$GetRoom(
        variables: Variables$Query$GetRoom(
          id: roomId,
          bookingStatus: Enum$BookingStatus.ACTIVE,
        ),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (res.hasException) throw mapOperationException(res.exception!);
    return mapRoomDetails(res.parsedData!.room);
  }
}
