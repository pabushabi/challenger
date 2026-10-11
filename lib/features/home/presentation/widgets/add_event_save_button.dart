import 'package:flutter/material.dart';

class AddEventSaveButton extends StatelessWidget {
  const AddEventSaveButton({
    super.key,
    required this.onPressed,
    this.label = 'Сохранить',
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.check),
      label: Text(label),
    );
  }
}
