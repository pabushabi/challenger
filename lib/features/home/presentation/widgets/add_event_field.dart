import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';

class AddEventField extends StatelessWidget {
  const AddEventField({
    super.key,
    required this.def,
    required this.value,
    required this.onChanged,
    required this.onDateChanged,
  });

  final EventFieldDef def;
  final String value;
  final ValueChanged<String> onChanged;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    switch (def.type) {
      case FieldType.text:
        return TextFormField(
          initialValue: value,
          decoration: InputDecoration(labelText: def.label),
          textCapitalization: TextCapitalization.sentences,
          onChanged: onChanged,
        );
      case FieldType.number:
        return TextFormField(
          initialValue: value,
          decoration: InputDecoration(labelText: def.label),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          onChanged: onChanged,
        );
      case FieldType.date:
        final parsed = DateTime.tryParse(value) ?? DateTime.now();
        final formatted = DateFormat('d MMMM yyyy', 'ru').format(parsed);
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: parsed,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              locale: const Locale('ru'),
            );
            if (picked != null) {
              onDateChanged(picked);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: def.label,
              suffixIcon: const Icon(Icons.calendar_today_outlined),
            ),
            child: Text(
              formatted,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        );
    }
  }
}
