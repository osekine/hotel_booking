#!/bin/bash
set -euo pipefail

# Run this from repo root: project/
ROOT_DIR="$(pwd)"
WIDGET_DIR="$ROOT_DIR/client/windows_widget"

mkdir -p "$WIDGET_DIR/lib/di"
mkdir -p "$WIDGET_DIR/lib/src/models"
mkdir -p "$WIDGET_DIR/lib/src/services"
mkdir -p "$WIDGET_DIR/lib/src/utils"
mkdir -p "$WIDGET_DIR/lib/features/dashboard/widgets"
mkdir -p "$WIDGET_DIR/test"

cat > "$WIDGET_DIR/pubspec.yaml" <<'YAML'
name: windows_widget
description: Mini Windows widget (Flutter desktop) for booking status
publish_to: "none"
version: 0.1.0

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  domain:
    path: ../packages/domain
  api_client:
    path: ../packages/api_client
  graphql_flutter: ^5.2.0-beta.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
YAML

cat > "$WIDGET_DIR/lib/main.dart" <<'DART'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  runApp(const ProviderScope(child: WindowsWidgetApp()));
}
DART

cat > "$WIDGET_DIR/lib/app.dart" <<'DART'
import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_page.dart';

class WindowsWidgetApp extends StatelessWidget {
  const WindowsWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Widget',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        visualDensity: VisualDensity.compact,
      ),
      home: const DashboardPage(),
    );
  }
}
DART

cat > "$WIDGET_DIR/lib/di/providers.dart" <<'DART'
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

cat > "$WIDGET_DIR/lib/src/utils/date.dart" <<'DART'
DateTime startOfDayLocal(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

String fmtDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final yyyy = d.year.toString().padLeft(4, '0');
  return '$dd.$mm.$yyyy';
}

String fmtDateTime(DateTime d) {
  final hh = d.hour.toString().padLeft(2, '0');
  final mi = d.minute.toString().padLeft(2, '0');
  return '${fmtDate(d)} $hh:$mi';
}
DART

cat > "$WIDGET_DIR/lib/src/utils/error_to_ui.dart" <<'DART'
import 'package:domain/domain.dart';

String errorToUserMessage(Object error) {
  if (error is BookingConflictFailure) {
    return 'Конфликт бронирования. Конфликтов: ${error.conflictsCount}.';
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

cat > "$WIDGET_DIR/lib/src/models/hotel_summary.dart" <<'DART'
import 'package:domain/domain.dart';

class RoomStatus {
  final Room room;
  final bool isAvailableToday;
  final DateTime? nearestBookingStart; // min startDate среди ACTIVE
  const RoomStatus({
    required this.room,
    required this.isAvailableToday,
    required this.nearestBookingStart,
  });
}

class HotelSummary {
  final Hotel hotel;
  final int freeToday;
  final int busyToday;
  final DateTime? nearestBookingStart; // min по всем комнатам
  final List<RoomStatus> rooms;

  const HotelSummary({
    required this.hotel,
    required this.freeToday,
    required this.busyToday,
    required this.nearestBookingStart,
    required this.rooms,
  });
}
DART

cat > "$WIDGET_DIR/lib/src/services/hotel_summary_service.dart" <<'DART'
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
DART

cat > "$WIDGET_DIR/lib/features/dashboard/dashboard_providers.dart" <<'DART'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/providers.dart';
import '../../src/services/hotel_summary_service.dart';
import '../../src/models/hotel_summary.dart';

final hotelSummaryServiceProvider = Provider<HotelSummaryService>((ref) {
  return HotelSummaryService(
    hotelRepo: ref.watch(hotelRepoProvider),
    roomRepo: ref.watch(roomRepoProvider),
    bookingRepo: ref.watch(bookingRepoProvider),
  );
});

final hotelSummariesProvider = FutureProvider<List<HotelSummary>>((ref) async {
  final service = ref.watch(hotelSummaryServiceProvider);
  return service.loadSummaries();
});
DART

cat > "$WIDGET_DIR/lib/features/dashboard/widgets/hotel_summary_card.dart" <<'DART'
import 'package:flutter/material.dart';
import '../../../src/models/hotel_summary.dart';
import '../../../src/utils/date.dart';

class HotelSummaryCard extends StatelessWidget {
  final HotelSummary summary;
  const HotelSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final h = summary.hotel;
    final nearest = summary.nearestBookingStart;

    return Card(
      child: ExpansionTile(
        title: Text(h.name),
        subtitle: Text('${h.city} • свободно: ${summary.freeToday} • занято: ${summary.busyToday}'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          Row(
            children: [
              const Icon(Icons.event, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  nearest == null ? 'Ближайших броней нет' : 'Ближайшая бронь: ${fmtDateTime(nearest)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ...summary.rooms.map((rs) {
            final r = rs.room;
            final statusText = rs.isAvailableToday ? 'Свободно сегодня' : 'Занято сегодня';
            final nearestRoom = rs.nearestBookingStart;

            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(rs.isAvailableToday ? Icons.check_circle : Icons.block),
              title: Text('№${r.number}${(r.title?.trim().isNotEmpty ?? false) ? ' — ${r.title}' : ''}'),
              subtitle: Text(
                nearestRoom == null
                    ? statusText
                    : '$statusText • ближайшая: ${fmtDateTime(nearestRoom)}',
              ),
              trailing: Text('€${r.priceEur}'),
            );
          }),
        ],
      ),
    );
  }
}
DART

cat > "$WIDGET_DIR/lib/features/dashboard/dashboard_page.dart" <<'DART'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../src/utils/error_to_ui.dart';
import 'dashboard_providers.dart';
import 'widgets/hotel_summary_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaries = ref.watch(hotelSummariesProvider);

    Future<void> refresh() async {
      await ref.refresh(hotelSummariesProvider.future);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Отели — статус сегодня'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить',
            onPressed: () => refresh(),
          ),
        ],
      ),
      body: summaries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(
          message: errorToUserMessage(e),
          onRetry: refresh,
        ),
        data: (items) => RefreshIndicator(
          onRefresh: refresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => HotelSummaryCard(summary: items[i]),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(message),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => onRetry(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Повторить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
DART

cat > "$WIDGET_DIR/test/hotel_summary_service_test.dart" <<'DART'
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
DART

echo "✅ Created windows_widget app at: $WIDGET_DIR"
echo ""
echo "Next steps:"
echo "1) Ensure backend is up: docker compose up --build"
echo "2) Ensure api_client codegen is done: (cd client/packages/api_client && ./tool/build.sh)"
echo "3) Run widget:"
echo "   cd client/windows_widget && flutter pub get"
echo "   flutter run -d windows --dart-define=API_BASE_URL=http://localhost:4000/graphql"
echo ""
echo "Run tests:"
echo "   cd client/windows_widget && flutter test"