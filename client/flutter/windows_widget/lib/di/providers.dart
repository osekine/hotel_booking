import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:api_client/api_client.dart';
import 'package:domain/domain.dart';

final apiConfigProvider = Provider<ApiConfig>((ref) {
  const url = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:4000/graphql',
  );
  return ApiConfig(graphqlUrl: url);
});

final graphQlClientProvider = Provider((ref) {
  final cfg = ref.watch(apiConfigProvider);
  return GraphQLClientFactory(graphqlUrl: cfg.graphqlUrl).create();
});

final hotelRepoProvider = Provider<HotelRepository>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return GqlHotelRepository(client);
});

final roomRepoProvider = Provider<RoomRepository>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return GqlRoomRepository(client);
});

final bookingRepoProvider = Provider<BookingRepository>((ref) {
  final client = ref.watch(graphQlClientProvider);
  return GqlBookingRepository(client);
});
