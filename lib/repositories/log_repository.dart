import 'dart:math';

import 'package:fitsanny/model/set.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/utils/database_constants.dart';
import 'package:sqflite/sqflite.dart';

class LogRepository {
  LogRepository(Database database) : _database = database;

  final Database _database;

  Future<List<Log>> getLatestLogsForTraining(int trainingId) async {
    final rows = await _database.rawQuery('''
    SELECT
      l.id AS log_id,
      l.training_id,
      l.exercise_id,
      l.reps AS log_reps,
      l.kgs AS log_kgs,
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
    final Map<int, Log> logsMap = {};
    for (final row in rows) {
      final int logId = int.parse(row['log_id'] as String);
      if (logsMap.keys.contains(logId)) {
        // add another set
        final Log log = logsMap[logId]!;
        logsMap[logId] = log.copyWith(
          sets: [
            ...log.sets,
            Set(
              id: int.tryParse(row['set_id'] as String),
              exerciseId: int.tryParse(row['set_exercise_id'] as String)!,
              logId: logId,
              reps: int.tryParse(row['set_reps'] as String)!,
              kgs: double.tryParse(row['set_kgs'] as String)!,
            ),
          ],
        );
      } else {
        logsMap[logId] = Log(
          id: int.tryParse(logId as String),
          trainingId: trainingId,
          createdAt: DateTime.tryParse(row['created_at'] as String),
          sets: [
            Set(
              id: int.tryParse(row['set_id'] as String),
              exerciseId: int.tryParse(row['set_exercise_id'] as String)!,
              logId: logId,
              reps: int.tryParse(row['set_reps'] as String)!,
              kgs: double.tryParse(row['set_kgs'] as String)!,
            ),
          ],
        );
      }
    }

    return logsMap.values.toList();
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
    final List<Log> logs = [];
    await _database.transaction((txn) async {
      for (Log log in logs) {
        log = log.copyWith(
          id: await txn.insert(
            getDatabaseTable(DatabaseTablesEnum.log),
            log.toMap(),
            conflictAlgorithm: ConflictAlgorithm.fail,
          ),
        );

        log.sets.map((Set set) async {
          return set.copyWith(
            id: await txn.insert(
              getDatabaseTable(DatabaseTablesEnum.set),
              set.copyWith(logId: log.id).toMap(),
              conflictAlgorithm: ConflictAlgorithm.fail,
            ),
          );
        });

        logs.add(log);
      }
    });
    return logs;
  }
}
