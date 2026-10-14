import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinochallenge/core/constants/cubit_state.dart';
import 'package:kinochallenge/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:kinochallenge/features/setup/presentation/cubit/setup_cubit.dart';
import 'package:kinochallenge/features/setup/presentation/widgets/setup_date_field.dart';
import 'package:kinochallenge/features/setup/presentation/widgets/setup_form.dart';
import 'package:kinochallenge/features/setup/presentation/widgets/setup_header.dart';
import 'package:kinochallenge/features/setup/presentation/widgets/setup_restore_button.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  Future<void> _onRestore(BuildContext context) async {
    final result = await context.read<SetupCubit>().restoreFromBackup();
    if (!context.mounted || result == null) {
      return;
    }
    if (result) {
      context.read<ThemeCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SetupCubit, SetupState>(
          listener: (context, state) {
            if (state.status == CubitState.success) {
              context.go('/');
            }
          },
          builder: (context, state) {
            final busy = state.status == CubitState.loading;
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              children: [
                const SetupHeader(),
                const SizedBox(height: 32),
                SetupForm(state: state),
                const SizedBox(height: 16),
                SetupDateField(
                  label: 'Дата начала',
                  value: state.startDate,
                  onChanged: context.read<SetupCubit>().updateStartDate,
                ),
                const SizedBox(height: 12),
                SetupDateField(
                  label: 'Дата окончания',
                  value: state.endDate,
                  onChanged: context.read<SetupCubit>().updateEndDate,
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ],
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () => context.read<SetupCubit>().submit(),
                  child: busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Начать'),
                ),
                const SizedBox(height: 12),
                SetupRestoreButton(
                  enabled: !busy,
                  onPressed: () => _onRestore(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
