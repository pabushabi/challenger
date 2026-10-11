import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:kinochallenge/core/constants/cubit_state.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';

part 'add_event_cubit.freezed.dart';
part 'add_event_state.dart';

class AddEventCubit extends Cubit<AddEventState> {
  AddEventCubit({
    required List<EventFieldDef> fieldDefs,
    Map<String, String>? initialValues,
    bool isEditing = false,
  }) : super(
          AddEventState.initial(
            fieldDefs,
            initialValues: initialValues,
            isEditing: isEditing,
          ),
        );

  void updateField(String fieldId, String value) {
    final next = Map<String, String>.from(state.values)..[fieldId] = value;
    emit(state.copyWith(values: next, errorMessage: null));
  }

  void updateDateField(String fieldId, DateTime date) {
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    updateField(fieldId, formatted);
  }

  Map<String, String>? validateAndBuild() {
    for (final def in state.fieldDefs) {
      final value = state.values[def.id]?.trim() ?? '';
      if (def.type == FieldType.number && value.isNotEmpty) {
        if (num.tryParse(value.replaceAll(',', '.')) == null) {
          emit(
            state.copyWith(
              errorMessage: 'Поле «${def.label}» должно быть числом',
            ),
          );
          return null;
        }
      }
    }
    emit(state.copyWith(status: CubitState.success));
    return state.values;
  }
}
