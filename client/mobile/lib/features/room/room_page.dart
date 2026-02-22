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
