import 'package:fitsanny/model/goal.dart';
import 'package:fitsanny/utils/database_constants.dart';
import 'package:sqflite/sqflite.dart';

class GoalRepository {
  final Database _database;

  GoalRepository(this._database);

  Future<Goal> insertGoal(Goal goal) async {
    final id = await _database.insert(
      getDatabaseTable(DatabaseTablesEnum.goal),
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return goal.copyWith(id: id);
  }

  Future<List<Goal>> getGoals() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      getDatabaseTable(DatabaseTablesEnum.goal),
    );
    return List.generate(maps.length, (i) {
      return Goal.fromJson(maps[i]);
    });
  }

  Future<Goal?> getGoalByExerciseId(int exerciseId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      getDatabaseTable(DatabaseTablesEnum.goal),
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
    );

    if (maps.isNotEmpty) {
      return Goal.fromJson(maps.first);
    }
    return null;
  }

  Future<int> updateGoal(Goal goal) async {
    return await _database.update(
      getDatabaseTable(DatabaseTablesEnum.goal),
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<int> deleteGoal(int id) async {
    return await _database.delete(
      getDatabaseTable(DatabaseTablesEnum.goal),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
