import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';
import 'package:kinochallenge/features/setup/presentation/widgets/setup_date_field.dart';

class SettingsChallengeSection extends StatefulWidget {
  const SettingsChallengeSection({
    super.key,
    required this.challenge,
    required this.onSave,
    required this.onStartNew,
  });

  final Challenge challenge;
  final Future<void> Function({
    required String name,
    required int targetCount,
    required DateTime startDate,
    required DateTime endDate,
  }) onSave;
  final VoidCallback onStartNew;

  @override
  State<SettingsChallengeSection> createState() =>
      _SettingsChallengeSectionState();
}

class _SettingsChallengeSectionState extends State<SettingsChallengeSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.challenge.name);
    _targetController =
        TextEditingController(text: '${widget.challenge.targetCount}');
    _startDate = widget.challenge.startDate;
    _endDate = widget.challenge.endDate;
  }

  @override
  void didUpdateWidget(covariant SettingsChallengeSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.challenge.id != widget.challenge.id) {
      _nameController.text = widget.challenge.name;
      _targetController.text = '${widget.challenge.targetCount}';
      _startDate = widget.challenge.startDate;
      _endDate = widget.challenge.endDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Текущий челлендж',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Название'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _targetController,
          decoration: const InputDecoration(labelText: 'Целевое количество'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 12),
        SetupDateField(
          label: 'Дата начала',
          value: _startDate,
          onChanged: (d) => setState(() => _startDate = d),
        ),
        const SizedBox(height: 12),
        SetupDateField(
          label: 'Дата окончания',
          value: _endDate,
          onChanged: (d) => setState(() => _endDate = d),
        ),
        const SizedBox(height: 12),
        Text(
          'Период: ${DateFormat('d MMM yyyy', 'ru').format(_startDate)} — '
          '${DateFormat('d MMM yyyy', 'ru').format(_endDate)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {
                  final target = int.tryParse(_targetController.text.trim());
                  if (target == null || target <= 0) {
                    return;
                  }
                  widget.onSave(
                    name: _nameController.text,
                    targetCount: target,
                    startDate: _startDate,
                    endDate: _endDate,
                  );
                },
                child: const Text('Сохранить'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onStartNew,
                child: const Text('Новый'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
