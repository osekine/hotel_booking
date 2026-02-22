import 'package:api_client/src/graphql/graphql_api.gen.dart';
import 'package:domain/domain.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../mappers/dto_mapper.dart';
import '../mappers/error_mapper.dart';

class GqlHotelRepository implements HotelRepository {
  final GraphQLClient _client;
  GqlHotelRepository(this._client);

  @override
  Future<List<Hotel>> getHotels() async {
    final res = await _client.query$GetHotels(
      Options$Query$GetHotels(fetchPolicy: FetchPolicy.networkOnly),
    );
    if (res.hasException) throw mapOperationException(res.exception!);
    return res.parsedData!.hotels.map(mapHotel).toList();
  }
}
