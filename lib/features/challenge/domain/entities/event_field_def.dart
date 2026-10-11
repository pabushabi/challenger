import 'package:equatable/equatable.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';

class EventFieldDef extends Equatable {
  const EventFieldDef({
    required this.id,
    required this.challengeId,
    required this.label,
    required this.type,
    required this.isDefault,
    required this.sortOrder,
  });

  final String id;
  final String challengeId;
  final String label;
  final FieldType type;
  final bool isDefault;
  final int sortOrder;

  EventFieldDef copyWith({
    String? id,
    String? challengeId,
    String? label,
    FieldType? type,
    bool? isDefault,
    int? sortOrder,
  }) {
    return EventFieldDef(
      id: id ?? this.id,
      challengeId: challengeId ?? this.challengeId,
      label: label ?? this.label,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [id, challengeId, label, type, isDefault, sortOrder];
}
