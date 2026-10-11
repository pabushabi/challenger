import 'package:flutter/material.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';

class SettingsFieldListItem extends StatelessWidget {
  const SettingsFieldListItem({
    super.key,
    required this.fieldDef,
    this.onDelete,
  });

  final EventFieldDef fieldDef;
  final VoidCallback? onDelete;

  IconData get _typeIcon {
    switch (fieldDef.type) {
      case FieldType.text:
        return Icons.short_text_rounded;
      case FieldType.number:
        return Icons.pin_outlined;
      case FieldType.date:
        return Icons.calendar_today_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              child: Icon(
                _typeIcon,
                size: 20,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fieldDef.label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fieldDef.isDefault
                        ? '${fieldDef.type.labelRu} · по умолчанию'
                        : fieldDef.type.labelRu,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, color: scheme.error),
                tooltip: 'Удалить',
              ),
          ],
        ),
      ),
    );
  }
}
