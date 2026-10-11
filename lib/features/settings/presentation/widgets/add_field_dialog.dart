import 'package:flutter/material.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';

class AddFieldDialog extends StatefulWidget {
  const AddFieldDialog({super.key});

  @override
  State<AddFieldDialog> createState() => _AddFieldDialogState();
}

class _AddFieldDialogState extends State<AddFieldDialog> {
  final _controller = TextEditingController();
  FieldType _type = FieldType.text;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новое поле'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Название поля'),
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<FieldType>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Тип'),
            items: [
              for (final type in FieldType.values)
                DropdownMenuItem(value: type, child: Text(type.labelRu)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _type = value);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () {
            final label = _controller.text.trim();
            if (label.isEmpty) {
              return;
            }
            Navigator.pop(context, (label, _type));
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}
