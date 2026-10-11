import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';

abstract class ChallengeRepository {
  Future<Challenge?> getActiveChallenge();

  Stream<Challenge?> watchActiveChallenge();

  Future<Challenge> createChallenge({
    required String name,
    required int targetCount,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<void> updateChallenge({
    required String id,
    required String name,
    required int targetCount,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<void> deactivateChallenge(String id);

  Future<void> addEvent({
    required String challengeId,
    required Map<String, String> fieldValues,
  });

  Future<void> updateEvent({
    required String eventId,
    required Map<String, String> fieldValues,
  });

  Future<void> deleteEvent(String eventId);

  Future<EventFieldDef> addFieldDef({
    required String challengeId,
    required String label,
    required FieldType type,
  });

  Future<void> updateFieldDef({
    required String id,
    required String label,
    required FieldType type,
  });

  Future<void> deleteFieldDef(String id);
}
