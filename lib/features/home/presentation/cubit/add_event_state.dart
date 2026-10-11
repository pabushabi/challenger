part of 'add_event_cubit.dart';

@Freezed(makeCollectionsUnmodifiable: false)
sealed class AddEventState with _$AddEventState {
  const factory AddEventState({
    @Default(CubitState.initial) CubitState status,
    required List<EventFieldDef> fieldDefs,
    required Map<String, String> values,
    @Default(false) bool isEditing,
    String? errorMessage,
  }) = _AddEventState;

  const AddEventState._();

  factory AddEventState.initial(
    List<EventFieldDef> fieldDefs, {
    Map<String, String>? initialValues,
    bool isEditing = false,
  }) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final values = <String, String>{};
    for (final def in fieldDefs) {
      final existing = initialValues?[def.id];
      if (existing != null) {
        values[def.id] = existing;
      } else if (def.type == FieldType.date) {
        values[def.id] = today;
      } else {
        values[def.id] = '';
      }
    }
    return AddEventState(
      fieldDefs: fieldDefs,
      values: values,
      isEditing: isEditing,
    );
  }
}
