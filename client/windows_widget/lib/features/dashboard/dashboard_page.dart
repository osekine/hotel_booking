import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import '../../src/utils/error_to_ui.dart';
import 'dashboard_providers.dart';
import 'widgets/hotel_summary_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();

    // Применяем pin
    ref.listen<bool>(alwaysOnTopProvider, (_, next) async {
      await windowManager.setAlwaysOnTop(next);
    });

    // Применяем прозрачность
    ref.listen<double>(windowOpacityProvider, (_, next) async {
      // window_manager: setOpacity(opacity) :contentReference[oaicite:2]{index=2}
      await windowManager.setOpacity(next);
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(hotelSummariesProvider);
    final pinned = ref.watch(alwaysOnTopProvider);
    final opacity = ref.watch(windowOpacityProvider);

    Future<void> refresh() async {
      await ref.refresh(hotelSummariesProvider.future);
    }

    Future<void> openOpacityDialog() async {
      await showDialog<void>(
        context: context,
        builder: (ctx) {
          double temp = opacity;
          return AlertDialog(
            title: const Text('Прозрачность окна'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slider(
                      value: temp,
                      min: 0.3,
                      max: 1.0,
                      divisions: 7,
                      label: '${(temp * 100).round()}%',
                      onChanged: (v) => setState(() => temp = v),
                    ),
                    Text('${(temp * 100).round()}%'),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(windowOpacityProvider.notifier).state = temp;
                  Navigator.of(ctx).pop();
                },
                child: const Text('Применить'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Отели — статус сегодня'),
        actions: [
          IconButton(
            tooltip: pinned ? 'Открепить окно' : 'Закрепить окно поверх всех',
            icon: Icon(pinned ? Icons.push_pin : Icons.push_pin_outlined),
            onPressed: () {
              ref.read(alwaysOnTopProvider.notifier).state = !pinned;
            },
          ),
          IconButton(
            tooltip: 'Прозрачность окна',
            icon: const Icon(Icons.opacity),
            onPressed: openOpacityDialog,
          ),
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

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

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
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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
