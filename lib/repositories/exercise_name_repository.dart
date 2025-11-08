import 'package:fitsanny/model/exercise_name.dart';
import 'package:sqflite/sqlite_api.dart';

class ExerciseNameRepository {
  ExerciseNameRepository(Database database) : _database = database;

  final Database _database;

  Future<List<ExerciseName>> getExerciseNames() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'exercise_name',
    );

    return maps.map((map) {
      return ExerciseName.fromMap(map);
    }).toList();
  }

  Future<void> addExerciseName(String name) async {
    await _database.insert('exercise_name', {
      'name': name,
    }, conflictAlgorithm: ConflictAlgorithm.fail);
  }
}
