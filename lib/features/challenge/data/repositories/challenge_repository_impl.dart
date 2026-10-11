import 'package:drift/drift.dart';
import 'package:kinochallenge/features/challenge/data/database/app_database.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge.dart';
import 'package:kinochallenge/features/challenge/domain/entities/challenge_event.dart';
import 'package:kinochallenge/features/challenge/domain/entities/event_field_def.dart';
import 'package:kinochallenge/features/challenge/domain/entities/field_type.dart';
import 'package:kinochallenge/features/challenge/domain/repositories/challenge_repository.dart';
import 'package:uuid/uuid.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  ChallengeRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  @override
  Future<Challenge?> getActiveChallenge() async {
    final row = await (_db.select(_db.challenges)
          ..where((t) => t.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _mapChallenge(row);
  }

  @override
  Stream<Challenge?> watchActiveChallenge() {
    // Слушаем связанные таблицы: иначе добавление события не триггерит обновление.
    return _db
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _db.challenges,
            _db.events,
            _db.eventFieldDefs,
            _db.eventFieldValues,
          },
        )
        .watch()
        .asyncMap((_) => getActiveChallenge());
  }

  Future<Challenge> _mapChallenge(ChallengeRow row) async {
    final fieldDefs = await (_db.select(_db.eventFieldDefs)
          ..where((t) => t.challengeId.equals(row.id))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();

    final eventRows = await (_db.select(_db.events)
          ..where((t) => t.challengeId.equals(row.id))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    final events = <ChallengeEvent>[];
    for (final eventRow in eventRows) {
      final values = await (_db.select(_db.eventFieldValues)
            ..where((t) => t.eventId.equals(eventRow.id)))
          .get();
      events.add(
        ChallengeEvent(
          id: eventRow.id,
          challengeId: eventRow.challengeId,
          createdAt: eventRow.createdAt,
          values: {for (final v in values) v.fieldDefId: v.value},
        ),
      );
    }

    return Challenge(
      id: row.id,
      name: row.name,
      targetCount: row.targetCount,
      startDate: row.startDate,
      endDate: row.endDate,
      isActive: row.isActive,
      fieldDefs: fieldDefs
          .map(
            (f) => EventFieldDef(
              id: f.id,
              challengeId: f.challengeId,
              label: f.label,
              type: FieldType.fromName(f.type),
              isDefault: f.isDefault,
              sortOrder: f.sortOrder,
            ),
          )
          .toList(),
      events: events,
    );
  }

  @override
  Future<Challenge> createChallenge({
    required String name,
    required int targetCount,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final id = _uuid.v4();
    await _db.transaction(() async {
      await _db.into(_db.challenges).insert(
            ChallengesCompanion.insert(
              id: id,
              name: name.trim(),
              targetCount: targetCount,
              startDate: startDate,
              endDate: endDate,
              isActive: const Value(true),
            ),
          );

      await _db.into(_db.eventFieldDefs).insert(
            EventFieldDefsCompanion.insert(
              id: _uuid.v4(),
              challengeId: id,
              label: 'Название',
              type: FieldType.text.name,
              isDefault: const Value(true),
              sortOrder: 0,
            ),
          );
      await _db.into(_db.eventFieldDefs).insert(
            EventFieldDefsCompanion.insert(
              id: _uuid.v4(),
              challengeId: id,
              label: 'Дата',
              type: FieldType.date.name,
              isDefault: const Value(true),
              sortOrder: 1,
            ),
          );
    });

    final created = await getActiveChallenge();
    return created!;
  }

  @override
  Future<void> updateChallenge({
    required String id,
    required String name,
    required int targetCount,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await (_db.update(_db.challenges)..where((t) => t.id.equals(id))).write(
      ChallengesCompanion(
        name: Value(name.trim()),
        targetCount: Value(targetCount),
        startDate: Value(startDate),
        endDate: Value(endDate),
      ),
    );
  }

  @override
  Future<void> deactivateChallenge(String id) async {
    await (_db.update(_db.challenges)..where((t) => t.id.equals(id))).write(
      const ChallengesCompanion(isActive: Value(false)),
    );
  }

  @override
  Future<void> addEvent({
    required String challengeId,
    required Map<String, String> fieldValues,
  }) async {
    final eventId = _uuid.v4();
    await _db.transaction(() async {
      await _db.into(_db.events).insert(
            EventsCompanion.insert(
              id: eventId,
              challengeId: challengeId,
              createdAt: DateTime.now(),
            ),
          );

      for (final entry in fieldValues.entries) {
        await _db.into(_db.eventFieldValues).insert(
              EventFieldValuesCompanion.insert(
                id: _uuid.v4(),
                eventId: eventId,
                fieldDefId: entry.key,
                value: entry.value,
              ),
            );
      }
    });
  }

  @override
  Future<void> updateEvent({
    required String eventId,
    required Map<String, String> fieldValues,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.eventFieldValues)
            ..where((t) => t.eventId.equals(eventId)))
          .go();

      for (final entry in fieldValues.entries) {
        await _db.into(_db.eventFieldValues).insert(
              EventFieldValuesCompanion.insert(
                id: _uuid.v4(),
                eventId: eventId,
                fieldDefId: entry.key,
                value: entry.value,
              ),
            );
      }
    });
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.eventFieldValues)
            ..where((t) => t.eventId.equals(eventId)))
          .go();
      await (_db.delete(_db.events)..where((t) => t.id.equals(eventId))).go();
    });
  }

  @override
  Future<EventFieldDef> addFieldDef({
    required String challengeId,
    required String label,
    required FieldType type,
  }) async {
    final existing = await (_db.select(_db.eventFieldDefs)
          ..where((t) => t.challengeId.equals(challengeId)))
        .get();
    final sortOrder = existing.isEmpty
        ? 0
        : existing.map((e) => e.sortOrder).reduce((a, b) => a > b ? a : b) + 1;

    final id = _uuid.v4();
    await _db.into(_db.eventFieldDefs).insert(
          EventFieldDefsCompanion.insert(
            id: id,
            challengeId: challengeId,
            label: label.trim(),
            type: type.name,
            isDefault: const Value(false),
            sortOrder: sortOrder,
          ),
        );

    return EventFieldDef(
      id: id,
      challengeId: challengeId,
      label: label.trim(),
      type: type,
      isDefault: false,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<void> updateFieldDef({
    required String id,
    required String label,
    required FieldType type,
  }) async {
    await (_db.update(_db.eventFieldDefs)..where((t) => t.id.equals(id))).write(
      EventFieldDefsCompanion(
        label: Value(label.trim()),
        type: Value(type.name),
      ),
    );
  }

  @override
  Future<void> deleteFieldDef(String id) async {
    final def = await (_db.select(_db.eventFieldDefs)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (def == null || def.isDefault) {
      return;
    }

    await _db.transaction(() async {
      await (_db.delete(_db.eventFieldValues)
            ..where((t) => t.fieldDefId.equals(id)))
          .go();
      await (_db.delete(_db.eventFieldDefs)..where((t) => t.id.equals(id))).go();
    });
  }
}
