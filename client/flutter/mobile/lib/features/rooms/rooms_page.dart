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
                onTap: () => context.push('/rooms/${r.id}'),
              );
            },
          ),
        ),
      ),
    );
  }
}
