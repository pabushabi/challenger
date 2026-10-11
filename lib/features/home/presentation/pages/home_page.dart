import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinochallenge/core/constants/cubit_state.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge_event.dart';
import 'package:kinochallenge/features/home/presentation/cubit/home_cubit.dart';
import 'package:kinochallenge/features/home/presentation/models/event_form_result.dart';
import 'package:kinochallenge/features/home/presentation/widgets/add_event_bottom_sheet.dart';
import 'package:kinochallenge/features/home/presentation/widgets/challenge_stats_section.dart';
import 'package:kinochallenge/features/home/presentation/widgets/events_list.dart';
import 'package:kinochallenge/features/home/presentation/widgets/home_add_fab.dart';
import 'package:kinochallenge/features/home/presentation/widgets/home_app_bar.dart';
import 'package:kinochallenge/features/home/presentation/widgets/home_deep_link_listener.dart';
import 'package:kinochallenge/features/home/presentation/widgets/home_empty_state.dart';
import 'package:kinochallenge/features/home/presentation/widgets/home_loading.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _openAddSheet(BuildContext context) async {
    final cubit = context.read<HomeCubit>();
    final challenge = cubit.state.challenge;
    if (challenge == null) {
      return;
    }

    final result = await showModalBottomSheet<EventFormResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddEventBottomSheet(fieldDefs: challenge.fieldDefs),
    );

    if (result?.action == EventFormAction.save &&
        result?.values != null &&
        context.mounted) {
      await cubit.addEvent(result!.values!);
    }
  }

  Future<void> _openEventSheet(
    BuildContext context,
    ChallengeEvent event,
  ) async {
    final cubit = context.read<HomeCubit>();
    final challenge = cubit.state.challenge;
    if (challenge == null) {
      return;
    }

    final result = await showModalBottomSheet<EventFormResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddEventBottomSheet(
        fieldDefs: challenge.fieldDefs,
        event: event,
      ),
    );

    if (!context.mounted || result == null) {
      return;
    }

    switch (result.action) {
      case EventFormAction.save:
        if (result.values != null) {
          await cubit.updateEvent(
            eventId: event.id,
            fieldValues: result.values!,
          );
        }
      case EventFormAction.delete:
        await cubit.deleteEvent(event.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeDeepLinkListener(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: HomeAppBar(
              onSettingsTap: () => context.push('/settings'),
            ),
            floatingActionButton: state.challenge == null
                ? null
                : HomeAddFab(
                    label: 'Добавить',
                    onPressed: () => _openAddSheet(context),
                  ),
            body: switch (state.status) {
              CubitState.loading || CubitState.initial => const HomeLoading(),
              CubitState.error => Center(
                  child: Text(state.errorMessage ?? 'Ошибка'),
                ),
              CubitState.success => state.challenge == null || state.stats == null
                  ? const HomeEmptyState()
                  : CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 6),
                          sliver: SliverToBoxAdapter(
                            child: ChallengeStatsSection(
                              challengeName: state.challenge!.name,
                              stats: state.stats!,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Text(
                              'Выполненные',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        EventsList(
                          challenge: state.challenge!,
                          onOpen: (event) => _openEventSheet(context, event),
                          onDelete: context.read<HomeCubit>().deleteEvent,
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 88)),
                      ],
                    ),
            },
          );
        },
      ),
    );
  }
}
