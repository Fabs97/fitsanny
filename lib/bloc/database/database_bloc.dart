import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_create_queries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  static const int _version = 1;
  static const String _dbName = 'fitsanny.db';

  DatabaseBloc() : super(InitialDatabaseState()) {
    on<InitializeDatabaseEvent>((event, emit) async {
      final databasePath = join(await getDatabasesPath(), _dbName);

      if (!await Directory(dirname(databasePath)).exists()) {
        await Directory(dirname(databasePath)).create(recursive: true);
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
          ].map((e) async => await db.execute(e)).toList();
        },
      );

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

  // Future<void> insertExercise(ExerciseDto exercise) async {
  //   final exerciseNameObj = await database.query(
  //     'exercise_name',
  //     where: 'name = ?',
  //     whereArgs: [exercise.exerciseName],
  //   );

  //   await database.transaction((txn) async {
  //     if (exerciseNameObj.isEmpty) {
  //       await txn.insert('exercise_name', {
  //         'name': exercise.exerciseName,
  //       }, conflictAlgorithm: ConflictAlgorithm.ignore);
  //     } else {
  //       exercise = exercise.copyWith(
  //         exerciseNameId: exerciseNameObj.first['id'] as int,
  //       );
  //     }
  //     await txn.insert(
  //       'exercise',
  //       exercise.toExercise().toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   });
  // }

  // Future<void> addExerciseToTraining(int exerciseId, int trainingId) async {
  //   await database.insert('training_exercises', {
  //     'training_id': trainingId,
  //     'exercise_id': exerciseId,
  //   }, conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // Future<void> deleteTraining(int id) async {
  //   await database.transaction((txn) async {
  //     await txn.execute('DELETE FROM training WHERE id = ?', [id]);
  //     await txn.execute(
  //       'DELETE FROM training_exercises WHERE training_id = ?',
  //       [id],
  //     );
  //   });
  // }

  // Future<void> deleteExerciseFromTraining(
  //   int exerciseId,
  //   int trainingId,
  // ) async {
  //   await database.delete(
  //     'training_exercises',
  //     where: 'training_id = ? AND exercise_id = ?',
  //     whereArgs: [trainingId, exerciseId],
  //   );
  // }
}

extension DatabaseProvider on DatabaseBloc {
  static BlocProvider<DatabaseBloc> get provider =>
      BlocProvider<DatabaseBloc>(create: (context) => DatabaseBloc());
}
