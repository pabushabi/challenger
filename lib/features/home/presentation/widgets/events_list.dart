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

    return SliverList.separated(
      itemCount: challenge.events.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final event = challenge.events[index];
        return EventListItem(
          event: event,
          fieldDefs: challenge.fieldDefs,
          onDelete: () => onDelete(event.id),
        );
      },
    );
  }
}
