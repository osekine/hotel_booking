#! bin/bash
set -euo pipefail

ROOT_DIR="$(pwd)"

# Paths
DOMAIN_DIR="$ROOT_DIR/client/packages/domain"
API_CLIENT_DIR="$ROOT_DIR/client/packages/api_client"
MOBILE_DIR="$ROOT_DIR/client/mobile"

mkdir -p "$DOMAIN_DIR/lib/src/entities"
mkdir -p "$DOMAIN_DIR/lib/src/errors"
mkdir -p "$DOMAIN_DIR/lib/src/repositories"

mkdir -p "$API_CLIENT_DIR/lib/src/config"
mkdir -p "$API_CLIENT_DIR/lib/src/graphql"
mkdir -p "$API_CLIENT_DIR/lib/src/mappers"
mkdir -p "$API_CLIENT_DIR/lib/src/repositories"

mkdir -p "$MOBILE_DIR/lib/di"
mkdir -p "$MOBILE_DIR/lib/routing"
mkdir -p "$MOBILE_DIR/lib/utils"
mkdir -p "$MOBILE_DIR/lib/features/hotels"
mkdir -p "$MOBILE_DIR/lib/features/rooms"
mkdir -p "$MOBILE_DIR/lib/features/room"

############################################
# domain package
############################################

cat > "$DOMAIN_DIR/pubspec.yaml" <<'YAML'
name: domain
version: 0.1.0
environment:
  sdk: ">=3.3.0 <4.0.0"
dependencies:
  meta: ^1.11.0
YAML

cat > "$DOMAIN_DIR/lib/domain.dart" <<'DART'
library domain;

export 'src/entities/hotel.dart';
export 'src/entities/room.dart';
export 'src/entities/booking.dart';
export 'src/entities/availability.dart';
export 'src/entities/date_range.dart';

export 'src/errors/failures.dart';

export 'src/repositories/hotel_repository.dart';
export 'src/repositories/room_repository.dart';
export 'src/repositories/booking_repository.dart';
DART

cat > "$DOMAIN_DIR/lib/src/entities/hotel.dart" <<'DART'
class Hotel {
  final String id;
  final String name;
  final String city;

  const Hotel({required this.id, required this.name, required this.city});
}
DART

cat > "$DOMAIN_DIR/lib/src/entities/room.dart" <<'DART'
class Room {
  final String id;
  final String hotelId;
  final String number;
  final String? title;
  final int capacity;
  final int priceEur;

  const Room({
    required this.id,
    required this.hotelId,
    required this.number,
    required this.title,
    required this.capacity,
    required this.priceEur,
  });
}
DART

cat > "$DOMAIN_DIR/lib/src/entities/booking.dart" <<'DART'
enum BookingStatus { active, canceled }

class Booking {
  final String id;
  final String roomId;
  final String guestName;
  final DateTime startDate;
  final DateTime endDate;
  final BookingStatus status;
  final DateTime? createdAt;
  final DateTime? canceledAt;

  const Booking({
    required this.id,
    required this.roomId,
    required this.guestName,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.createdAt,
    this.canceledAt,
  });
}
DART

cat > "$DOMAIN_DIR/lib/src/entities/availability.dart" <<'DART'
import 'booking.dart';

class Availability {
  final String roomId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAvailable;
  final List<Booking> conflicts;

  const Availability({
    required this.roomId,
    required this.startDate,
    required this.endDate,
    required this.isAvailable,
    required this.conflicts,
  });
}
DART

cat > "$DOMAIN_DIR/lib/src/entities/date_range.dart" <<'DART'
class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end}) {
    if (!end.isAfter(start)) throw ArgumentError('end must be after start');
  }
}
DART

cat > "$DOMAIN_DIR/lib/src/errors/failures.dart" <<'DART'
sealed class Failure implements Exception {
  final String message;
  const Failure(this.message);
  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

class BookingConflictFailure extends Failure {
  final int conflictsCount;
  const BookingConflictFailure({
    required this.conflictsCount,
    super.message = 'Booking conflicts with existing booking(s)',
  });
}
DART

cat > "$DOMAIN_DIR/lib/src/repositories/hotel_repository.dart" <<'DART'
import '../entities/hotel.dart';

abstract interface class HotelRepository {
  Future<List<Hotel>> getHotels();
}
DART

cat > "$DOMAIN_DIR/lib/src/repositories/room_repository.dart" <<'DART'
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
DART

cat > "$DOMAIN_DIR/lib/src/repositories/booking_repository.dart" <<'DART'
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
DART

############################################
# api_client package
############################################

cat > "$API_CLIENT_DIR/pubspec.yaml" <<'YAML'
name: api_client
version: 0.1.0
environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  domain:
    path: ../domain
  graphql_flutter: ^5.2.0-beta.7
  meta: ^1.11.0

dev_dependencies:
  build_runner: ^2.4.9
  graphql_codegen: ^1.2.2
  lints: ^5.0.0
YAML

cat > "$API_CLIENT_DIR/build.yaml" <<'YAML'
targets:
  $default:
    builders:
      graphql_codegen:
        options:
          clients:
            - graphql
          scalars:
            DateTime:
              type: DateTime
              fromJsonFunctionName: fromJsonDateTime
              toJsonFunctionName: toJsonDateTime
          assetsPath: ../../../graphql/operations/*.graphql
          schemaPath: ../../../graphql/schema.graphql
          outputDirectory: lib/src/graphql/generated
          generatedFileName: graphql_api
YAML

cat > "$API_CLIENT_DIR/lib/api_client.dart" <<'DART'
library api_client;

export 'src/config/api_config.dart';
export 'src/graphql/client_factory.dart';
export 'src/repositories/gql_hotel_repository.dart';
export 'src/repositories/gql_room_repository.dart';
export 'src/repositories/gql_booking_repository.dart';
DART

cat > "$API_CLIENT_DIR/lib/src/config/api_config.dart" <<'DART'
class ApiConfig {
  final String graphqlUrl;
  const ApiConfig({required this.graphqlUrl});
}
DART

cat > "$API_CLIENT_DIR/lib/src/graphql/client_factory.dart" <<'DART'
import 'package:graphql_flutter/graphql_flutter.dart';

DateTime fromJsonDateTime(Object? json) => DateTime.parse(json! as String);
Object toJsonDateTime(DateTime value) => value.toUtc().toIso8601String();

class GraphQLClientFactory {
  final String graphqlUrl;
  GraphQLClientFactory({required this.graphqlUrl});

  GraphQLClient create() {
    final link = HttpLink(graphqlUrl);
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}
DART

cat > "$API_CLIENT_DIR/lib/src/mappers/error_mapper.dart" <<'DART'
import 'package:domain/domain.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Failure mapOperationException(OperationException ex) {
  if (ex.linkException != null) {
    return NetworkFailure(ex.linkException.toString());
  }

  if (ex.graphqlErrors.isNotEmpty) {
    final err = ex.graphqlErrors.first;
    final code = err.extensions?['code'];
    if (code == 'CONFLICT') {
      final count = (err.extensions?['conflictsCount'] as int?) ?? 0;
      return BookingConflictFailure(conflictsCount: count);
    }
    return UnknownFailure(err.message);
  }

  return UnknownFailure(ex.toString());
}
DART

cat > "$API_CLIENT_DIR/lib/src/mappers/dto_mapper.dart" <<'DART'
import 'package:domain/domain.dart';
import '../graphql/generated/graphql_api.graphql.dart';

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
      roomId: b.roomId,
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
DART

cat > "$API_CLIENT_DIR/lib/src/repositories/gql_hotel_repository.dart" <<'DART'
import 'package:domain/domain.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/generated/graphql_api.graphql.dart';
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
DART

cat > "$API_CLIENT_DIR/lib/src/repositories/gql_room_repository.dart" <<'DART'
import 'package:domain/domain.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/generated/graphql_api.graphql.dart';
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
DART

cat > "$API_CLIENT_DIR/lib/src/repositories/gql_booking_repository.dart" <<'DART'
import 'package:domain/domain.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/generated/graphql_api.graphql.dart';
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
DART

############################################
# mobile app
############################################

cat > "$MOBILE_DIR/pubspec.yaml" <<'YAML'
name: mobile
description: Mini booking system (Flutter)
publish_to: "none"
version: 0.1.0

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  go_router: ^14.2.0
  graphql_flutter: ^5.2.0-beta.7
  domain:
    path: ../packages/domain
  api_client:
    path: ../packages/api_client

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
YAML

cat > "$MOBILE_DIR/lib/main.dart" <<'DART'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routing/router.dart';

void main() {
  runApp(const ProviderScope(child: BookingApp()));
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: buildRouter(),
    );
  }
}
DART

cat > "$MOBILE_DIR/lib/routing/router.dart" <<'DART'
import 'package:go_router/go_router.dart';
import '../features/hotels/hotels_page.dart';
import '../features/rooms/rooms_page.dart';
import '../features/room/room_page.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/hotels',
    routes: [
      GoRoute(
        path: '/hotels',
        builder: (_, __) => const HotelsPage(),
        routes: [
          GoRoute(
            path: ':hotelId/rooms',
            builder: (_, state) => RoomsPage(hotelId: state.pathParameters['hotelId']!),
          ),
        ],
      ),
      GoRoute(
        path: '/rooms/:roomId',
        builder: (_, state) => RoomPage(roomId: state.pathParameters['roomId']!),
      ),
    ],
  );
}
DART

cat > "$MOBILE_DIR/lib/di/providers.dart" <<'DART'
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
DART

cat > "$MOBILE_DIR/lib/utils/date_fmt.dart" <<'DART'
String fmtDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final yyyy = d.year.toString().padLeft(4, '0');
  return '$dd.$mm.$yyyy';
}
DART

cat > "$MOBILE_DIR/lib/utils/error_to_ui.dart" <<'DART'
import 'package:domain/domain.dart';

String errorToUserMessage(Object error) {
  if (error is BookingConflictFailure) {
    final n = error.conflictsCount;
    return 'Даты заняты. Найдено конфликтов: $n.';
  }
  if (error is NetworkFailure) {
    return 'Проблема с сетью. Проверь подключение и попробуй снова.';
  }
  if (error is Failure) {
    return error.message;
  }
  return error.toString();
}
DART

# Hotels
cat > "$MOBILE_DIR/lib/features/hotels/hotels_providers.dart" <<'DART'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import '../../di/providers.dart';

final hotelsProvider = FutureProvider<List<Hotel>>((ref) async {
  final repo = ref.watch(hotelRepoProvider);
  return repo.getHotels();
});
DART

cat > "$MOBILE_DIR/lib/features/hotels/hotels_page.dart" <<'DART'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'hotels_providers.dart';

class HotelsPage extends ConsumerWidget {
  const HotelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotels = ref.watch(hotelsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Отели')),
      body: hotels.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            await ref.refresh(hotelsProvider.future);
          },
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final h = items[i];
              return ListTile(
                title: Text(h.name),
                subtitle: Text(h.city),
                onTap: () => context.go('/hotels/${h.id}/rooms'),
              );
            },
          ),
        ),
      ),
    );
  }
}
DART

# Rooms
cat > "$MOBILE_DIR/lib/features/rooms/rooms_providers.dart" <<'DART'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import '../../di/providers.dart';

final roomsProvider = FutureProvider.family<List<Room>, String>((ref, hotelId) async {
  final repo = ref.watch(roomRepoProvider);
  return repo.getRooms(hotelId: hotelId);
});
DART

cat > "$MOBILE_DIR/lib/features/rooms/rooms_page.dart" <<'DART'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'rooms_providers.dart';

class RoomsPage extends ConsumerWidget {
  final String hotelId;
  const RoomsPage({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomsProvider(hotelId));

    return Scaffold(
      appBar: AppBar(title: const Text('Номера')),
      body: rooms.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            await ref.refresh(roomsProvider(hotelId).future);
          },
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = items[i];
              final title = (r.title?.trim().isNotEmpty == true) ? r.title! : 'Номер ${r.number}';
              return ListTile(
                title: Text(title),
                subtitle: Text('Вместимость: ${r.capacity} • €${r.priceEur}/ночь'),
                trailing: Text('#${r.number}'),
                onTap: () => context.go('/rooms/${r.id}'),
              );
            },
          ),
        ),
      ),
    );
  }
}
DART

# Room (details/actions)
cat > "$MOBILE_DIR/lib/features/room/room_providers.dart" <<'DART'
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import '../../di/providers.dart';

final roomDetailsProvider = FutureProvider.family<RoomDetails, String>((ref, roomId) async {
  final repo = ref.watch(roomRepoProvider);
  return repo.getRoomDetails(roomId: roomId);
});

class RoomActionState {
  final DateTimeRange? selectedRange;
  final AsyncValue<Availability?> availability;
  final AsyncValue<void> lastAction;

  const RoomActionState({
    required this.selectedRange,
    required this.availability,
    required this.lastAction,
  });

  factory RoomActionState.initial() => const RoomActionState(
        selectedRange: null,
        availability: AsyncValue.data(null),
        lastAction: AsyncValue.data(null),
      );

  RoomActionState copyWith({
    DateTimeRange? selectedRange,
    AsyncValue<Availability?>? availability,
    AsyncValue<void>? lastAction,
  }) {
    return RoomActionState(
      selectedRange: selectedRange ?? this.selectedRange,
      availability: availability ?? this.availability,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}

class RoomActionController extends StateNotifier<RoomActionState> {
  final Ref ref;
  final String roomId;
  Timer? _debounce;

  RoomActionController(this.ref, this.roomId) : super(RoomActionState.initial());

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void setRange(DateTimeRange? range) {
    state = state.copyWith(
      selectedRange: range,
      availability: const AsyncValue.data(null),
    );

    if (range == null) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      // ignore: discarded_futures
      checkAvailability();
    });
  }

  Future<void> checkAvailability() async {
    final range = state.selectedRange;
    if (range == null) return;

    state = state.copyWith(availability: const AsyncValue.loading());
    final repo = ref.read(bookingRepoProvider);

    state = state.copyWith(
      availability: await AsyncValue.guard(() async {
        return repo.checkAvailability(
          roomId: roomId,
          start: range.start,
          end: range.end,
        );
      }),
    );
  }

  Future<void> createBooking({required String guestName}) async {
    final range = state.selectedRange;
    if (range == null) return;

    state = state.copyWith(lastAction: const AsyncValue.loading());
    final repo = ref.read(bookingRepoProvider);

    final res = await AsyncValue.guard(() async {
      await repo.createBooking(
        roomId: roomId,
        guestName: guestName,
        start: range.start,
        end: range.end,
      );
    });

    state = state.copyWith(lastAction: res);

    if (!res.hasError) {
      ref.invalidate(roomDetailsProvider(roomId));
      state = state.copyWith(availability: const AsyncValue.data(null));
    }
  }

  Future<void> cancelBooking({required String bookingId}) async {
    state = state.copyWith(lastAction: const AsyncValue.loading());
    final repo = ref.read(bookingRepoProvider);

    final res = await AsyncValue.guard(() async {
      await repo.cancelBooking(bookingId: bookingId);
    });

    state = state.copyWith(lastAction: res);

    if (!res.hasError) {
      ref.invalidate(roomDetailsProvider(roomId));
      state = state.copyWith(availability: const AsyncValue.data(null));
    }
  }
}

final roomActionControllerProvider =
    StateNotifierProvider.family<RoomActionController, RoomActionState, String>((ref, roomId) {
  return RoomActionController(ref, roomId);
});
DART

cat > "$MOBILE_DIR/lib/features/room/room_page.dart" <<'DART'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import '../../utils/date_fmt.dart';
import '../../utils/error_to_ui.dart';
import 'room_providers.dart';

class RoomPage extends ConsumerWidget {
  final String roomId;
  const RoomPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(roomDetailsProvider(roomId));
    final actions = ref.watch(roomActionControllerProvider(roomId));
    final controller = ref.read(roomActionControllerProvider(roomId).notifier);

    ref.listen(roomActionControllerProvider(roomId).select((s) => s.lastAction), (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorToUserMessage(e))),
          );
        },
      );
    });

    ref.listen(roomActionControllerProvider(roomId).select((s) => s.availability), (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorToUserMessage(e))),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Номер')),
      body: details.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(errorToUserMessage(e))),
        data: (d) {
          final r = d.room;
          final title = (r.title?.trim().isNotEmpty == true) ? r.title! : 'Номер ${r.number}';

          return RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(roomDetailsProvider(roomId).future);
              // сброс устаревшей availability
              controller.setRange(actions.selectedRange);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Вместимость: ${r.capacity} • €${r.priceEur}/ночь • #${r.number}'),
                const SizedBox(height: 16),

                _DateRangeCard(
                  range: actions.selectedRange,
                  onPick: () async {
                    final now = DateTime.now();
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(now.year, now.month, now.day),
                      lastDate: DateTime(now.year + 2),
                      initialDateRange: actions.selectedRange,
                    );
                    if (picked != null) controller.setRange(picked);
                  },
                  onClear: () => controller.setRange(null),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: actions.selectedRange == null || actions.availability.isLoading
                            ? null
                            : () => controller.checkAvailability(),
                        child: actions.availability.isLoading
                            ? const SizedBox(
                                height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Проверить доступность'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                actions.availability.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text(errorToUserMessage(e)),
                  data: (a) {
                    if (a == null) return const SizedBox.shrink();
                    return _AvailabilityCard(a: a);
                  },
                ),

                const SizedBox(height: 12),

                _BookingActions(
                  isBusy: actions.lastAction.isLoading,
                  availability: actions.availability.valueOrNull,
                  onBook: (guestName) => controller.createBooking(guestName: guestName),
                ),

                const SizedBox(height: 24),

                Text('Активные брони', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),

                if (d.bookings.isEmpty)
                  const Text('Нет активных броней.')
                else
                  ...d.bookings.map((b) => _BookingTile(
                        booking: b,
                        onCancel: actions.lastAction.isLoading
                            ? null
                            : () => controller.cancelBooking(bookingId: b.id),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DateRangeCard extends StatelessWidget {
  final DateTimeRange? range;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const _DateRangeCard({required this.range, required this.onPick, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final text = range == null ? 'Диапазон не выбран' : '${fmtDate(range!.start)} → ${fmtDate(range!.end)}';

    return Card(
      child: ListTile(
        title: const Text('Даты'),
        subtitle: Text(text),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onPick, icon: const Icon(Icons.date_range)),
            if (range != null) IconButton(onPressed: onClear, icon: const Icon(Icons.clear)),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  final Availability a;
  const _AvailabilityCard({required this.a});

  @override
  Widget build(BuildContext context) {
    if (a.isAvailable) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.check_circle),
          title: Text('Доступно'),
          subtitle: Text('Конфликтов не найдено'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.error),
              title: Text('Недоступно'),
              subtitle: Text('Есть конфликты'),
            ),
            const SizedBox(height: 8),
            ...a.conflicts.map((c) => Text('• ${c.guestName}: ${fmtDate(c.startDate)} → ${fmtDate(c.endDate)}')),
          ],
        ),
      ),
    );
  }
}

class _BookingActions extends StatefulWidget {
  final bool isBusy;
  final Availability? availability;
  final Future<void> Function(String guestName) onBook;

  const _BookingActions({required this.isBusy, required this.availability, required this.onBook});

  @override
  State<_BookingActions> createState() => _BookingActionsState();
}

class _BookingActionsState extends State<_BookingActions> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateName(String raw) {
    final name = raw.trim();
    if (name.isEmpty) return 'Введите имя гостя';
    if (name.length < 2) return 'Имя слишком короткое';
    if (name.length > 50) return 'Имя слишком длинное (макс 50)';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final canBook = widget.availability?.isAvailable == true && !widget.isBusy;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Имя гостя'),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canBook
                    ? () async {
                        final err = _validateName(_controller.text);
                        if (err != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                          return;
                        }
                        await widget.onBook(_controller.text.trim());
                      }
                    : null,
                child: widget.isBusy
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Забронировать'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCancel;

  const _BookingTile({required this.booking, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(booking.guestName),
        subtitle: Text('${fmtDate(booking.startDate)} → ${fmtDate(booking.endDate)}'),
        trailing: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: onCancel,
          tooltip: 'Отменить бронь',
        ),
      ),
    );
  }
}
DART

echo ""
echo "✅ Flutter/packages files written."
echo ""
echo "Next steps:"
echo "1) (api_client) cd client/packages/api_client && dart pub get && dart run build_runner build --delete-conflicting-outputs"
echo "2) (mobile) cd client/mobile && flutter pub get"
echo "3) flutter run --dart-define=API_BASE_URL=http://localhost:4000/graphql (iOS) or http://10.0.2.2:4000/graphql (Android emulator)"