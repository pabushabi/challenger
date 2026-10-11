import 'package:flutter/material.dart';

class AddEventSaveButton extends StatelessWidget {
  const AddEventSaveButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.check),
      label: const Text('Сохранить'),
    );
  }
}
