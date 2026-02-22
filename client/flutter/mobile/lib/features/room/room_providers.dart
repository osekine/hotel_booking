import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/domain.dart';
import '../../di/providers.dart';

final roomDetailsProvider =
    FutureProvider.family<RoomDetails, String>((ref, roomId) async {
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

  static const _unset = Object();

  RoomActionState copyWith({
    Object? selectedRange = _unset, // <-- важно
    AsyncValue<Availability?>? availability,
    AsyncValue<void>? lastAction,
  }) {
    return RoomActionState(
      selectedRange: identical(selectedRange, _unset)
          ? this.selectedRange
          : selectedRange as DateTimeRange?, // <-- позволяет null
      availability: availability ?? this.availability,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}

class RoomActionController extends StateNotifier<RoomActionState> {
  final Ref ref;
  final String roomId;
  Timer? _debounce;

  RoomActionController(this.ref, this.roomId)
      : super(RoomActionState.initial());

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

    final next = await AsyncValue.guard(() async {
      return repo.checkAvailability(
        roomId: roomId,
        start: range.start,
        end: range.end,
      );
    });

    state = state.copyWith(availability: next);

    // ✅ Если есть конфликты — обновляем список активных броней комнаты
    final a = next.valueOrNull;
    if (a != null && !a.isAvailable) {
      ref.invalidate(roomDetailsProvider(roomId));
    }
  }

  Future<void> createBooking({required String guestName}) async {
    final range = state.selectedRange;
    if (range == null) return;

    state = state.copyWith(lastAction: const AsyncValue.loading());
    final repo = ref.read(bookingRepoProvider);

    final res = await AsyncValue.guard(() async {
      try {
        await repo.createBooking(
          roomId: roomId,
          guestName: guestName,
          start: range.start,
          end: range.end,
        );
      } catch (e) {
        // ✅ если конфликт — обновим список броней (могли появиться “чужие” брони)
        if (e is BookingConflictFailure) {
          ref.invalidate(roomDetailsProvider(roomId));
        }
        rethrow;
      }
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
    StateNotifierProvider.family<RoomActionController, RoomActionState, String>(
        (ref, roomId) {
  return RoomActionController(ref, roomId);
});
