import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/home/presentation/cubit/add_event_cubit.dart';
import 'package:kinochallenge/features/home/presentation/widgets/add_event_bottom_sheet_body.dart';

class AddEventBottomSheet extends StatelessWidget {
  const AddEventBottomSheet({super.key, required this.fieldDefs});

  final List<EventFieldDef> fieldDefs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddEventCubit(fieldDefs: fieldDefs),
      child: const AddEventBottomSheetBody(),
    );
  }
}
