import 'package:flutter/material.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';
import 'package:kinochallenge/features/home/presentation/widgets/event_list_item.dart';
import 'package:kinochallenge/features/home/presentation/widgets/events_empty_placeholder.dart';

class EventsList extends StatelessWidget {
  const EventsList({
    super.key,
    required this.challenge,
    required this.onDelete,
  });

  final Challenge challenge;
  final ValueChanged<String> onDelete;

  @override
  Widget build(BuildContext context) {
    if (challenge.events.isEmpty) {
      return const SliverToBoxAdapter(child: EventsEmptyPlaceholder());
    }

    final total = challenge.events.length;

    return SliverList.builder(
      itemCount: challenge.events.length,
      itemBuilder: (context, index) {
        final event = challenge.events[index];
        return EventListItem(
          event: event,
          fieldDefs: challenge.fieldDefs,
          index: total - index - 1,
          onDelete: () => onDelete(event.id),
        );
      },
    );
  }
}
