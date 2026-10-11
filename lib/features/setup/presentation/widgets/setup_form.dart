import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinochallenge/features/setup/presentation/cubit/setup_cubit.dart';

class SetupForm extends StatelessWidget {
  const SetupForm({super.key, required this.state});

  final SetupState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: state.name,
          decoration: const InputDecoration(
            labelText: 'Название челленджа',
            hintText: 'Например, 100 фильмов',
          ),
          textCapitalization: TextCapitalization.sentences,
          onChanged: context.read<SetupCubit>().updateName,
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: state.targetCountText,
          decoration: const InputDecoration(
            labelText: 'Целевое количество',
            hintText: '100',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: context.read<SetupCubit>().updateTargetCount,
        ),
      ],
    );
  }
}
