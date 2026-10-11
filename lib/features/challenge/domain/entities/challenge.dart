import 'package:equatable/equatable.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge_event.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';

class Challenge extends Equatable {
  const Challenge({
    required this.id,
    required this.name,
    required this.targetCount,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.fieldDefs,
    required this.events,
  });

  final String id;
  final String name;
  final int targetCount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final List<EventFieldDef> fieldDefs;
  final List<ChallengeEvent> events;

  int get completedCount => events.length;

  Challenge copyWith({
    String? id,
    String? name,
    int? targetCount,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<EventFieldDef>? fieldDefs,
    List<ChallengeEvent>? events,
  }) {
    return Challenge(
      id: id ?? this.id,
      name: name ?? this.name,
      targetCount: targetCount ?? this.targetCount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      fieldDefs: fieldDefs ?? this.fieldDefs,
      events: events ?? this.events,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        targetCount,
        startDate,
        endDate,
        isActive,
        fieldDefs,
        events,
      ];
}
