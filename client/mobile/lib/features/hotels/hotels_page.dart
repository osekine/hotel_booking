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
                onTap: () => context.push('/hotels/${h.id}/rooms'),
              );
            },
          ),
        ),
      ),
    );
  }
}
