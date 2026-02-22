import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import '../../di/providers.dart';

final hotelsProvider = FutureProvider<List<Hotel>>((ref) async {
  final repo = ref.watch(hotelRepoProvider);
  return repo.getHotels();
});
