import 'dart:io';

import 'package:fitsanny/bloc/database/database_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCubit extends Cubit<DatabaseState> {
  static const int _version = 1;
  static const String _dbName = 'fitsanny.db';

  DatabaseCubit() : super(InitialDatabaseState());

  Database? database;

  Future<void> initDatabase() async {
    final databasePath = join(await getDatabasesPath(), _dbName);

    if (!await Directory(dirname(databasePath)).exists()) {
      await Directory(dirname(databasePath)).create(recursive: true);
    }

    database = await openDatabase(
      databasePath,
      version: _version,
      onCreate: (db, version) async {
        // Database creation logic here
        // ExerciseName table
        await db.execute(
          'CREATE TABLE exercise_name(id INTEGER PRIMARY KEY, name TEXT)',
        );
        // Exercise table
        await db.execute(
          'CREATE TABLE exercise(id INTEGER PRIMARY KEY, exerciseNameId INTEGER, reps INTEGER, kgs REAL, FOREIGN KEY(exerciseNameId) REFERENCES exercise_name(id))',
        );
        // Training table
        await db.execute(
          'CREATE TABLE training(id INTEGER PRIMARY KEY, title TEXT)',
        );
        // Training_Exercises junction table
        await db.execute(
          'CREATE TABLE training_exercises(training_id INTEGER, exercise_id INTEGER, FOREIGN KEY(training_id) REFERENCES training(id), FOREIGN KEY(exercise_id) REFERENCES exercise(id))',
        );
      },
    );

    emit(LoadedDatabaseState());
  }

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

extension DatabaseProvider on DatabaseCubit {
  static BlocProvider<DatabaseCubit> get provider =>
      BlocProvider<DatabaseCubit>(
        create: (context) => DatabaseCubit()..initDatabase(),
      );
}
