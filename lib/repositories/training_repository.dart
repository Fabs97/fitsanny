import 'package:fitsanny/model/exercise.dart';
import 'package:fitsanny/model/training.dart';
import 'package:fitsanny/utils/database_constants.dart';
import 'package:sqflite/sqflite.dart';

class TrainingRepository {
  TrainingRepository(Database database) : _database = database;

  final Database _database;

  Future<Training> insertTraining(Training training) async {
    final newTrainingId = await _database.transaction<int>((txn) async {
      try {
        training = training.copyWith(
          exercises: await Future.wait(
            training.exercises.map((e) async {
              if (e.id != null) return e;
              final id = await txn.insert(
                getDatabaseTable(DatabaseTablesEnum.exercise),
                e.toMap(),
              );
              return e.copyWith(id: id);
            }),
          ),
        );

        int id = await txn.insert(
          'training',
          training.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        for (var exercise in training.exercises) {
          await txn.insert(
            getDatabaseTable(DatabaseTablesEnum.trainingExercise),
            {'training_id': id, 'exercise_id': exercise.id},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        return id;
      } catch (e) {
        throw Exception('Failed to insert training: $e');
      }
    });

    return training.copyWith(id: newTrainingId);
  }

  Future<List<Training>> getTrainings() async {
    final List<Map<String, dynamic>> trainingMaps = await _database.query(
      'training',
    );

    List<Training> trainings = [];
    for (var trainingMap in trainingMaps) {
      final List<Map<String, dynamic>> exerciseMaps = await _database.rawQuery(
        'SELECT e.*, en.name FROM ${getDatabaseTable(DatabaseTablesEnum.exercise)} e '
        'LEFT JOIN ${getDatabaseTable(DatabaseTablesEnum.exerciseName)} en ON e.exercise_name_id = en.id '
        'LEFT JOIN ${getDatabaseTable(DatabaseTablesEnum.trainingExercise)} te ON e.id = te.exercise_id '
        'WHERE te.training_id = ?',
        [trainingMap['id']],
      );

      List<Exercise> exercises = exerciseMaps
          .map((e) => Exercise.fromJson(e))
          .toList();

      trainings.add(
        Training(
          id: trainingMap['id'],
          title: trainingMap['title'],
          description: trainingMap['description'],
          exercises: exercises,
        ),
      );
    }

    return trainings;
  }

  Future<bool> deleteTraining(int id) async {
    final rowsAffected = await _database.delete(
      getDatabaseTable(DatabaseTablesEnum.training),
      where: 'id = ?',
      whereArgs: [id],
    );

    return rowsAffected == 1;
  }

  Future<void> updateTraining(Training training) async {
    await _database.transaction((txn) async {
      // 1. Update Training Title
      await txn.update(
        getDatabaseTable(DatabaseTablesEnum.training),
        training.toMap(),
        where: 'id = ?',
        whereArgs: [training.id],
      );

      // 2. Handle Exercises
      // First, ensure all exercises have IDs (insert new ones)
      final updatedExercises = await Future.wait(
        training.exercises.map((e) async {
          if (e.id != null) {
            // Update existing exercise details (reps, kgs, name)
            await txn.update(
              getDatabaseTable(DatabaseTablesEnum.exercise),
              e.toMap(),
              where: 'id = ?',
              whereArgs: [e.id],
            );
            return e;
          } else {
            // Insert new exercise
            final id = await txn.insert(
              getDatabaseTable(DatabaseTablesEnum.exercise),
              e.toMap(),
            );
            return e.copyWith(id: id);
          }
        }),
      );

      // 3. Update Training-Exercise Associations
      // Simplest approach: Delete all existing associations for this training and re-insert
      await txn.delete(
        getDatabaseTable(DatabaseTablesEnum.trainingExercise),
        where: 'training_id = ?',
        whereArgs: [training.id],
      );

      for (var exercise in updatedExercises) {
        await txn.insert(
          getDatabaseTable(DatabaseTablesEnum.trainingExercise),
          {'training_id': training.id, 'exercise_id': exercise.id},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<Training?> getTraining(int id) async {
    final List<Map<String, dynamic>> trainingMaps = await _database.query(
      'training',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (trainingMaps.isEmpty) return null;

    final trainingMap = trainingMaps.first;
    final List<Map<String, dynamic>> exerciseMaps = await _database.rawQuery(
      'SELECT e.*, en.name FROM ${getDatabaseTable(DatabaseTablesEnum.exercise)} e '
      'LEFT JOIN ${getDatabaseTable(DatabaseTablesEnum.exerciseName)} en ON e.exercise_name_id = en.id '
      'LEFT JOIN ${getDatabaseTable(DatabaseTablesEnum.trainingExercise)} te ON e.id = te.exercise_id '
      'WHERE te.training_id = ?',
      [trainingMap['id']],
    );

    List<Exercise> exercises = exerciseMaps
        .map((e) => Exercise.fromJson(e))
        .toList();

    return Training(
      id: trainingMap['id'],
      title: trainingMap['title'],
      description: trainingMap['description'],
      exercises: exercises,
    );
  }
}
