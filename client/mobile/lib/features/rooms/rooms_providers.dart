import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import '../../di/providers.dart';

final roomsProvider = FutureProvider.family<List<Room>, String>((ref, hotelId) async {
  final repo = ref.watch(roomRepoProvider);
  return repo.getRooms(hotelId: hotelId);
});
