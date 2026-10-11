import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinochallenge/features/home/presentation/cubit/add_event_cubit.dart';
import 'package:kinochallenge/features/home/presentation/models/event_form_result.dart';
import 'package:kinochallenge/features/home/presentation/widgets/add_event_delete_button.dart';
import 'package:kinochallenge/features/home/presentation/widgets/add_event_field.dart';
import 'package:kinochallenge/features/home/presentation/widgets/add_event_save_button.dart';

class AddEventBottomSheetBody extends StatelessWidget {
  const AddEventBottomSheetBody({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить отметку?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.of(context).pop(const EventFormResult.delete());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).systemGestureInsets.bottom;
    return BlocBuilder<AddEventCubit, AddEventState>(
      builder: (context, state) {
        final title = state.isEditing ? 'Отметка' : 'Новая отметка';
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (state.isEditing) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Просмотр и изменение выполненной отметки',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    for (final def in state.fieldDefs) ...[
                      AddEventField(
                        key: ValueKey(def.id),
                        def: def,
                        value: state.values[def.id] ?? '',
                        onChanged: (v) =>
                            context.read<AddEventCubit>().updateField(def.id, v),
                        onDateChanged: (d) => context
                            .read<AddEventCubit>()
                            .updateDateField(def.id, d),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (state.errorMessage != null)
                      Text(
                        state.errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    if (state.isEditing) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AddEventDeleteButton(
                          onPressed: () => _confirmDelete(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: AddEventSaveButton(
                  label: state.isEditing ? 'Сохранить' : 'Сохранить',
                  onPressed: () {
                    final values =
                        context.read<AddEventCubit>().validateAndBuild();
                    if (values != null) {
                      Navigator.of(context).pop(EventFormResult.save(values));
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
