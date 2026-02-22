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

final alwaysOnTopProvider = StateProvider<bool>((ref) => false);

// 1.0 = полностью непрозрачное окно
final windowOpacityProvider = StateProvider<double>((ref) => 1.0);