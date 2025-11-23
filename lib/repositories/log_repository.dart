import 'dart:math';

import 'package:fitsanny/model/set.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/utils/database_constants.dart';
import 'package:fitsanny/utils/logs_utils.dart';
import 'package:sqflite/sqflite.dart';

class LogRepository {
  LogRepository(Database database) : _database = database;

  final Database _database;

  Future<List<Log>> getLatestLogsForTraining(int trainingId) async {
    final rows = await _database.rawQuery('''
    SELECT
      l.id AS log_id,
      l.training_id,
      l.created_at,
      s.id AS set_id,
      s.exercise_id AS set_exercise_id,
      s.reps AS set_reps,
      s.kgs AS set_kgs
    FROM
      ${getDatabaseTable(DatabaseTablesEnum.log)} l
    JOIN
      ${getDatabaseTable(DatabaseTablesEnum.set)} s ON s.log_id = l.id
    WHERE
      l.training_id = $trainingId
      AND l.created_at = (
        SELECT MAX(created_at)
        FROM log
        WHERE training_id = $trainingId
      )
    ''');

    return fromLogsWithSetMapToFlutterClasses(rows);
  }

  Future<List<Log>> getLogsBetween(
    DateTime start,
    DateTime end, {
    String? exerciseName,
    int? limit = 10,
  }) async {
    final startStr = start
        .toIso8601String()
        .substring(0, 19)
        .replaceFirst('T', ' ');
    final endStr = end
        .toIso8601String()
        .substring(0, 19)
        .replaceFirst('T', ' ');

    // Base query parts
    final logTable = getDatabaseTable(DatabaseTablesEnum.log);
    final setTable = getDatabaseTable(DatabaseTablesEnum.set);
    final exerciseTable = getDatabaseTable(DatabaseTablesEnum.exercise);
    final exerciseNameTable = getDatabaseTable(DatabaseTablesEnum.exerciseName);

    final baseSelect = '''
    SELECT
      l.id AS log_id,
      l.training_id,
      l.created_at,
      t.title AS training_name,
      s.id AS set_id,
      s.exercise_id AS set_exercise_id,
      s.reps AS set_reps,
      s.kgs AS set_kgs
  ''';

    final baseFrom =
        '''
    FROM $logTable l
    JOIN $setTable s ON s.log_id = l.id
    LEFT JOIN ${getDatabaseTable(DatabaseTablesEnum.training)} t ON l.training_id = t.id
  ''';

    // Optional join + where parts
    String joinClause = '';
    String whereClause = 'WHERE l.created_at BETWEEN ? AND ?';
    final whereArgs = [startStr, endStr];

    if (exerciseName != null && exerciseName.isNotEmpty) {
      joinClause =
          '''
      JOIN $exerciseTable e ON s.exercise_id = e.id
      JOIN $exerciseNameTable en ON e.exercise_name_id = en.id
    ''';
      whereClause += ' AND LOWER(en.name) = ?';
      whereArgs.add(exerciseName);
    }

    final orderBy = 'ORDER BY l.created_at DESC';

    final limitClause = 'LIMIT 10';

    final sql =
        '''
    $baseSelect
    $baseFrom
    $joinClause
    $whereClause
    $orderBy
    $limitClause
  ''';

    final rows = await _database.rawQuery(sql, whereArgs);

    return fromLogsWithSetMapToFlutterClasses(rows);
  }

  Future<Log> insertLog(Log log) async {
    final newLogId = await _database.insert(
      getDatabaseTable(DatabaseTablesEnum.log),
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    return log.copyWith(id: newLogId);
  }

  Future<List<Log>> insertLogs(List<Log> logs) async {
    final List<Log> newLogs = [];
    await _database.transaction((txn) async {
      for (Log log in logs) {
        log = log.copyWith(
          id: await txn.insert(
            getDatabaseTable(DatabaseTablesEnum.log),
            log.toMap(),
            conflictAlgorithm: ConflictAlgorithm.fail,
          ),
        );

        final newSets = <Set>[];
        for (final set in log.sets) {
          final newSetId = await txn.insert(
            getDatabaseTable(DatabaseTablesEnum.set),
            set.copyWith(logId: log.id).toMap(),
            conflictAlgorithm: ConflictAlgorithm.fail,
          );
          newSets.add(set.copyWith(id: newSetId));
        }
        log = log.copyWith(sets: newSets);

        newLogs.add(log);
      }
    });
    return newLogs;
  }

  Future<Set?> getLatestSetForExercise(int exerciseNameId) async {
    final rows = await _database.rawQuery(
      '''
    SELECT
      s.id,
      s.exercise_id,
      s.log_id,
      s.reps,
      s.kgs
    FROM
      ${getDatabaseTable(DatabaseTablesEnum.set)} s
    JOIN
      ${getDatabaseTable(DatabaseTablesEnum.log)} l ON s.log_id = l.id
    JOIN
      ${getDatabaseTable(DatabaseTablesEnum.exercise)} e ON s.exercise_id = e.id
    WHERE
      e.exercise_name_id = ?
    ORDER BY
      l.created_at DESC
    LIMIT 1
    ''',
      [exerciseNameId],
    );

    if (rows.isNotEmpty) {
      return Set.fromMap(rows.first);
    }
    return null;
  }

  Future<void> updateLog(Log log) async {
    await _database.transaction((txn) async {
      // Update the log entry
      await txn.update(
        getDatabaseTable(DatabaseTablesEnum.log),
        log.toMap(),
        where: 'id = ?',
        whereArgs: [log.id],
      );

      // Delete existing sets for this log
      await txn.delete(
        getDatabaseTable(DatabaseTablesEnum.set),
        where: 'log_id = ?',
        whereArgs: [log.id],
      );

      // Insert new sets
      for (final set in log.sets) {
        await txn.insert(
          getDatabaseTable(DatabaseTablesEnum.set),
          set.copyWith(logId: log.id).toMap(),
          conflictAlgorithm: ConflictAlgorithm.fail,
        );
      }
    });
  }
}
