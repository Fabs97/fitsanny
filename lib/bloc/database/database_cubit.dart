import 'dart:io';
import 'package:fitsanny/utils/database_constants.dart';
import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_create_queries.dart';
import 'package:fitsanny/services/file_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'database_state.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  static const int _version = 3;
  static const String _dbName = 'fitsanny.db';

  DatabaseCubit() : super(InitialDatabaseState());

  Database? database;

  Future<String> get databasePath async =>
      join(await getDatabasesPath(), _dbName);

  Future<void> initializeDatabase() async {
    final databasePath = join(await getDatabasesPath(), _dbName);
    var exists = await databaseExists(databasePath);

    if (!exists) {
      // Make sure the directory exists
      try {
        await Directory(dirname(databasePath)).create(recursive: true);
      } catch (_) {}

      // Check if backup exists and try to restore
      final fileService = FileService();
      final hasBackup = await fileService.hasBackup();

      if (hasBackup) {
        print('📦 Backup found, attempting to restore...');
        final restored = await fileService.restoreDatabase(databasePath);

        if (!restored) {
          // Restore failed, will create new database via onCreate
          print('⚠️ Restore failed, will create new database');
        }
      } else {
        // No backup exists, will create new database via onCreate
        print('📝 No backup found, will create new database');
      }
    }

    // Open database with version control - this will trigger onCreate or onUpgrade
    database = await openDatabase(
      databasePath,
      version: _version,
      onCreate: (db, version) async {
        print('🆕 Creating new database with version $version');
        // Create all tables
        await db.execute(createExerciseNameTableQuery);
        await db.execute(createExerciseTableQuery);
        await db.execute(createTrainingTableQuery);
        await db.execute(createTrainingExercisesTableQuery);
        await db.execute(createLoggerTableQuery);
        await db.execute(createSetTableQuery);
        await db.execute(createGoalTableQuery);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('🔄 Upgrading database from version $oldVersion to $newVersion');
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE ${getDatabaseTable(DatabaseTablesEnum.training)} ADD COLUMN description TEXT',
          );
        }
        if (oldVersion < 3) {
          await db.execute(createGoalTableQuery);
        }
      },
    );

    // Manual migration check - ensures schema is up to date even for restored backups
    await _ensureSchemaUpToDate();

    await database?.execute('PRAGMA foreign_keys = ON');
    await _insertDefaultExercises();

    emit(LoadedDatabaseState(database!));
  }

  /// Manually check and update schema if needed
  /// This is necessary because restored backups might not trigger onUpgrade
  Future<void> _ensureSchemaUpToDate() async {
    try {
      // Check if description column exists in training table
      final result = await database!.rawQuery('PRAGMA table_info(training)');
      final hasDescription = result.any(
        (column) => column['name'] == 'description',
      );

      if (!hasDescription) {
        print('⚠️ Missing description column, adding it now...');
        await database!.execute(
          'ALTER TABLE ${getDatabaseTable(DatabaseTablesEnum.training)} ADD COLUMN description TEXT',
        );
        print('✅ Description column added successfully');
      }

      // Check if goal table exists
      final tables = await database!.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='goal'",
      );

      if (tables.isEmpty) {
        print('⚠️ Missing goal table, creating it now...');
        await database!.execute(createGoalTableQuery);
        print('✅ Goal table created successfully');
      }
    } catch (e) {
      print('Error ensuring schema is up to date: $e');
    }
  }

  Future<void> closeDatabase() async {
    await database?.close();
    emit(ClosedDatabaseState());
  }

  Future<void> loadDatabase() async {
    if (database != null) {
      emit(LoadedDatabaseState(database!));
    } else {
      emit(ErrorDatabaseState('Database not initialized'));
    }
  }

  Future<void> _insertDefaultExercises() async {
    // Insert exercise names if they don't already exist
    for (final name in baseExercises) {
      await database!.insert(
        getDatabaseTable(DatabaseTablesEnum.exerciseName),
        {'name': name},
        conflictAlgorithm: ConflictAlgorithm.ignore, // avoids duplicates
      );
    }

    // Optionally, insert base exercises (empty stats) to the exercise table
    final existingNames = await database!.query(
      getDatabaseTable(DatabaseTablesEnum.exerciseName),
    );
    for (final e in existingNames) {
      await database!.insert(
        getDatabaseTable(DatabaseTablesEnum.exercise),
        {'exercise_name_id': e['id'], 'reps': 0, 'kgs': 0.0},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    print('✅ Default exercises inserted (${baseExercises.length})');
  }
}

extension DatabaseProvider on DatabaseCubit {
  static BlocProvider<DatabaseCubit> get provider =>
      BlocProvider<DatabaseCubit>(create: (context) => DatabaseCubit());
}
