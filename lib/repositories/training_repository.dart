import 'package:fitsanny/model/exercise.dart';
import 'package:fitsanny/model/training.dart';
import 'package:sqflite/sqflite.dart';

class TrainingRepository {
  TrainingRepository(Database database) : _database = database;

  final Database _database;

  Future<Training> insertTraining(Training training) async {
    final newTrainingId = await _database.transaction<int>((txn) async {
      try {
        int id = await txn.insert(
          'training',
          training.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        for (var exercise in training.exercises) {
          await txn.insert('training_exercises', {
            'training_id': id,
            'exercise_id': exercise.id,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
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
}
