import 'package:fitsanny/model/dto/exercise_dto.dart';
import 'package:fitsanny/model/exercise.dart';
import 'package:fitsanny/model/training.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = 'fitsanny.db';

  static Future<Database> _getDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _dbName);

    return openDatabase(
      path,
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
  }

  static Future<Database> get database async {
    return _getDB();
  }

  static Future<void> insertExercise(ExerciseDto exercise) async {
    final db = await database;
    final exerciseNameObj = await db.query(
      'exercise_name',
      where: 'name = ?',
      whereArgs: [exercise.exerciseName],
    );

    await db.transaction((txn) async {
      if (exerciseNameObj.isEmpty) {
        await txn.insert('exercise_name', {
          'name': exercise.exerciseName,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      } else {
        exercise = exercise.copyWith(
          exerciseNameId: exerciseNameObj.first['id'] as int,
        );
      }
      await txn.insert(
        'exercise',
        exercise.toExercise().toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  static Future<void> insertTraining(Training training) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.insert(
        'training',
        training.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      for (var exercise in training.exercises) {
        await txn.insert('training_exercises', {
          'training_id': training.id,
          'exercise_id': exercise.id,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  static Future<List<Training>> getTrainings() async {
    final db = await database;
    final List<Map<String, dynamic>> trainingMaps = await db.query('training');

    List<Training> trainings = [];
    for (var trainingMap in trainingMaps) {
      final List<Map<String, dynamic>> exerciseMaps = await db.rawQuery(
        'SELECT e.* FROM exercise e '
        'JOIN training_exercises te ON e.id = te.exercise_id '
        'WHERE te.training_id = ?',
        [trainingMap['id']],
      );

      List<Exercise> exercises = exerciseMaps.map((e) {
        return Exercise(
          id: e['id'],
          exerciseNameId: e['exerciseNameId'],
          reps: e['reps'],
          kgs: e['kgs'],
        );
      }).toList();

      trainings.add(
        Training(
          id: trainingMap['id'],
          title: trainingMap['title'],
          exercises: exercises,
        ),
      );
    }

    return trainings;
  }

  static Future<void> addExerciseToTraining(
    int exerciseId,
    int trainingId,
  ) async {
    final db = await database;
    await db.insert('training_exercises', {
      'training_id': trainingId,
      'exercise_id': exerciseId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteTraining(int id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.execute('DELETE FROM training WHERE id = ?', [id]);
      await txn.execute(
        'DELETE FROM training_exercises WHERE training_id = ?',
        [id],
      );
    });
  }

  static Future<void> deleteExerciseFromTraining(
    int exerciseId,
    int trainingId,
  ) async {
    final db = await database;
    await db.delete(
      'training_exercises',
      where: 'training_id = ? AND exercise_id = ?',
      whereArgs: [trainingId, exerciseId],
    );
  }
}
