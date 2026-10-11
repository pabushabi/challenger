import 'package:flutter/material.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/add_field_dialog.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_field_list_item.dart';
import 'package:kinochallenge/features/settings/presentation/widgets/settings_section_card.dart';

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
    return SettingsSectionCard(
      title: 'Поля события',
      subtitle: 'Появятся при добавлении отметки на главном экране',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < fieldDefs.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            SettingsFieldListItem(
              fieldDef: fieldDefs[i],
              onDelete: fieldDefs[i].isDefault
                  ? null
                  : () => onDelete(fieldDefs[i].id),
            ),
          ],
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => _showAddDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Добавить поле'),
          ),
        ],
      ),
    );
  }
}
