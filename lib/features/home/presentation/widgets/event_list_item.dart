import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge_event.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({
    super.key,
    required this.event,
    required this.fieldDefs,
    required this.onDelete,
  });

  final ChallengeEvent event;
  final List<EventFieldDef> fieldDefs;
  final VoidCallback onDelete;

  String _displayValue(EventFieldDef def) {
    final raw = event.values[def.id] ?? '';
    if (raw.isEmpty) {
      return '—';
    }
    if (def.type == FieldType.date) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) {
        return DateFormat('d MMM yyyy', 'ru').format(parsed);
      }
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleDef = fieldDefs.cast<EventFieldDef?>().firstWhere(
          (d) => d?.type == FieldType.text,
          orElse: () => null,
        );
    final title = titleDef != null
        ? (event.values[titleDef.id]?.trim().isNotEmpty == true
            ? event.values[titleDef.id]!
            : 'Без названия')
        : 'Событие';

    return Dismissible(
      key: ValueKey(event.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colorScheme.errorContainer,
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onErrorContainer),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          fieldDefs
              .where((d) => d.id != titleDef?.id)
              .map((d) => '${d.label}: ${_displayValue(d)}')
              .join(' · '),
        ),
      ),
    );
  }
}
