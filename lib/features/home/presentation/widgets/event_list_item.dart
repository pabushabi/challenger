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
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  final ChallengeEvent event;
  final List<EventFieldDef> fieldDefs;
  final int index;
  final VoidCallback onTap;
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

  Future<bool> _confirmDismiss(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить отметку?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final titleDef = fieldDefs.cast<EventFieldDef?>().firstWhere(
          (d) => d?.type == FieldType.text,
          orElse: () => null,
        );
    final title = titleDef != null
        ? (event.values[titleDef.id]?.trim().isNotEmpty == true
            ? event.values[titleDef.id]!
            : 'Без названия')
        : 'Событие';

    final details = fieldDefs
        .where((d) => d.id != titleDef?.id)
        .map((d) => '${d.label}: ${_displayValue(d)}')
        .join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Dismissible(
        key: ValueKey(event.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => _confirmDismiss(context),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: scheme.errorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.delete_outline,
            color: scheme.onErrorContainer,
          ),
        ),
        onDismissed: (_) => onDelete(),
        child: Material(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (details.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            details,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
