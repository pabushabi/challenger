import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';
import 'package:kinochallenge/features/home/presentation/cubit/home_cubit.dart';
import 'package:kinochallenge/features/home/presentation/models/event_form_result.dart';
import 'package:kinochallenge/features/home/presentation/widgets/add_event_bottom_sheet.dart';

class HomeDeepLinkListener extends StatefulWidget {
  const HomeDeepLinkListener({super.key, required this.child});

  final Widget child;

  @override
  State<HomeDeepLinkListener> createState() => _HomeDeepLinkListenerState();
}

class _HomeDeepLinkListenerState extends State<HomeDeepLinkListener> {
  @override
  void initState() {
    super.initState();
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_handleUri);
    HomeWidget.widgetClicked.listen(_handleUri);
  }

  Future<void> _handleUri(Uri? uri) async {
    if (uri == null || !mounted) {
      return;
    }
    if (uri.scheme != 'challenger' || uri.host != 'add') {
      return;
    }

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
        mounted) {
      await cubit.addEvent(result!.values!);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
