import 'package:flutter/material.dart';

class SetupRestoreButton extends StatelessWidget {
  const SetupRestoreButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: const Icon(Icons.download_outlined),
      label: const Text('Восстановить из бэкапа'),
    );
  }
}
