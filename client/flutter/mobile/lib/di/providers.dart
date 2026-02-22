import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:api_client/api_client.dart';
import 'package:domain/domain.dart';
import 'api_url.dart';

final apiConfigProvider = Provider<ApiConfig>((ref) {
  return ApiConfig(graphqlUrl: resolveGraphqlUrl());
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
