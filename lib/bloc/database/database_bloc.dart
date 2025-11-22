import 'dart:io';
import 'package:fitsanny/utils/database_constants.dart';
import 'package:flutter/services.dart';
import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_create_queries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  static const int _version = 3;
  static const String _dbName = 'fitsanny.db';

  DatabaseBloc() : super(InitialDatabaseState()) {
    on<InitializeDatabaseEvent>((event, emit) async {
      final databasePath = join(await getDatabasesPath(), _dbName);
      var exists = await databaseExists(databasePath);

      if (!exists) {
        // Make sure the directory exists
        try {
          await Directory(dirname(databasePath)).create(recursive: true);
        } catch (_) {}

        // Copy from asset
        ByteData data = await rootBundle.load('assets/$_dbName');
        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );

        // Write and flush the bytes
        await File(databasePath).writeAsBytes(bytes, flush: true);
      }

      database = await openDatabase(
        databasePath,
        version: _version,
        onCreate: (db, version) async {
          [
            createExerciseNameTableQuery,
            createExerciseTableQuery,
            createTrainingTableQuery,
            createTrainingExercisesTableQuery,
            createLoggerTableQuery,
            createSetTableQuery,
            createGoalTableQuery,
          ].map((e) async => await db.execute(e)).toList();
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute(
              'ALTER TABLE training ADD COLUMN description TEXT',
            );
          }
          if (oldVersion < 3) {
            await db.execute(createGoalTableQuery);
          }
        },
      );

      await database?.execute('PRAGMA foreign_keys = ON');
      await _insertDefaultExercises();

      emit(LoadedDatabaseState(database!));
    });
    on<CloseDatabaseEvent>((event, emit) async {
      await database?.close();
      emit(ClosedDatabaseState());
    });
    on<LoadDatabaseEvent>((event, emit) async {
      if (database != null) {
        emit(LoadedDatabaseState(database!));
      } else {
        emit(ErrorDatabaseState('Database not initialized'));
      }
    });
  }

  Database? database;

  Future<String> get databasePath async =>
      join(await getDatabasesPath(), _dbName);

  Future<void> _insertDefaultExercises() async {
    // Insert exercise names if they don’t already exist
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

extension DatabaseProvider on DatabaseBloc {
  static BlocProvider<DatabaseBloc> get provider =>
      BlocProvider<DatabaseBloc>(create: (context) => DatabaseBloc());
}
