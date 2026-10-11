import 'package:drift/drift.dart';

@DataClassName('ChallengeRow')
class Challenges extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get targetCount => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('EventFieldDefRow')
class EventFieldDefs extends Table {
  TextColumn get id => text()();
  TextColumn get challengeId => text().references(Challenges, #id)();
  TextColumn get label => text()();
  TextColumn get type => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('EventRow')
class Events extends Table {
  TextColumn get id => text()();
  TextColumn get challengeId => text().references(Challenges, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('EventFieldValueRow')
class EventFieldValues extends Table {
  TextColumn get id => text()();
  TextColumn get eventId => text().references(Events, #id)();
  TextColumn get fieldDefId => text().references(EventFieldDefs, #id)();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
