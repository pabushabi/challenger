import 'package:flutter/material.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/add_field_dialog.dart';

class SettingsFieldsSection extends StatelessWidget {
  const SettingsFieldsSection({
    super.key,
    required this.fieldDefs,
    required this.onAdd,
    required this.onDelete,
  });

  final List<EventFieldDef> fieldDefs;
  final void Function(String label, FieldType type) onAdd;
  final ValueChanged<String> onDelete;

  Future<void> _showAddDialog(BuildContext context) async {
    final result = await showDialog<(String, FieldType)>(
      context: context,
      builder: (_) => const AddFieldDialog(),
    );
    if (result != null) {
      onAdd(result.$1, result.$2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Поля события',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Эти поля появятся при добавлении отметки на главном экране.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        const SizedBox(height: 8),
        for (final def in fieldDefs)
          ListTile(
            title: Text(def.label),
            subtitle: Text(def.type.labelRu),
            trailing: def.isDefault
                ? Text(
                    'по умолчанию',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => onDelete(def.id),
                  ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: () => _showAddDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Добавить поле'),
          ),
        ),
      ],
    );
  }
}
