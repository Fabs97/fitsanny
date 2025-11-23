import 'package:fitsanny/bloc/database/database_create_queries.dart';
import 'package:fitsanny/model/set.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:fitsanny/utils/database_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database database;
  late LogRepository logRepository;

  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    database = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(createExerciseNameTableQuery);
        await db.execute(createExerciseTableQuery);
        await db.execute(createTrainingTableQuery);
        await db.execute(createTrainingExercisesTableQuery);
        await db.execute(createLoggerTableQuery);
        await db.execute(createSetTableQuery);
        await db.execute(createGoalTableQuery);
      },
    );
    logRepository = LogRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'getLatestSetForExercise returns set correctly linked via ExerciseName',
    () async {
      // 1. Insert ExerciseName "Bench Press" (ID: 1)
      final exerciseNameId = await database.insert(
        getDatabaseTable(DatabaseTablesEnum.exerciseName),
        {'name': 'Bench Press'},
      );

      // 2. Insert Exercise (ID: 10) linked to "Bench Press"
      final exerciseId = await database.insert(
        getDatabaseTable(DatabaseTablesEnum.exercise),
        {'exercise_name_id': exerciseNameId, 'reps': 0, 'kgs': 0.0},
      );

      // 3. Insert Training (ID: 100)
      final trainingId = await database.insert(
        getDatabaseTable(DatabaseTablesEnum.training),
        {'title': 'Chest Day'},
      );

      // 4. Insert Log (ID: 1000)
      final logId = await database.insert(
        getDatabaseTable(DatabaseTablesEnum.log),
        {
          'training_id': trainingId,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      // 5. Insert Set (ID: 500) linked to Log and Exercise
      final setId = await database.insert(
        getDatabaseTable(DatabaseTablesEnum.set),
        {'exercise_id': exerciseId, 'log_id': logId, 'reps': 10, 'kgs': 100.0},
      );

      // 6. Call getLatestSetForExercise with exerciseNameId (1)
      final result = await logRepository.getLatestSetForExercise(
        exerciseNameId,
      );

      // 7. Verify
      expect(result, isNotNull);
      expect(result!.id, setId);
      expect(result.reps, 10);
      expect(result.kgs, 100.0);
    },
  );

  test('getLatestSetForExercise returns null if no match', () async {
    final result = await logRepository.getLatestSetForExercise(999);
    expect(result, isNull);
  });
}
