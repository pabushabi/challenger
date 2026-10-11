import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinochallenge/features/home/presentation/cubit/add_event_cubit.dart';
import 'package:kinochallenge/features/home/presentation/widgets/add_event_field.dart';
import 'package:kinochallenge/features/home/presentation/widgets/add_event_save_button.dart';

class AddEventBottomSheetBody extends StatelessWidget {
  const AddEventBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return BlocBuilder<AddEventCubit, AddEventState>(
      builder: (context, state) {
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
                      'Новая отметка',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    for (final def in state.fieldDefs) ...[
                      AddEventField(
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
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: AddEventSaveButton(
                  onPressed: () {
                    final values =
                        context.read<AddEventCubit>().validateAndBuild();
                    if (values != null) {
                      Navigator.of(context).pop(values);
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
