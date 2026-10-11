import 'package:flutter/material.dart';

class SettingsVibrationTile extends StatelessWidget {
  const SettingsVibrationTile({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Вибрация'),
      subtitle: const Text('Отклик при добавлении отметки'),
      value: enabled,
      onChanged: onChanged,
    );
  }
}
