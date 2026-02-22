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
