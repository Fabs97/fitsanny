import 'dart:math';

import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/utils/database_constants.dart';
import 'package:sqflite/sqflite.dart';

class LogRepository {
  LogRepository(Database database) : _database = database;

  final Database _database;

  Future<List<Log>> getLogsForTraining(int trainingId) async {
    final logMaps = await _database.query(
      getDatabaseTable(DatabaseTablesEnum.log),
      where: "training_id = ?",
      whereArgs: [trainingId],
    );

    return logMaps.map((log) => Log.fromJson(log)).toList();
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
      for (final log in logs) {
        logs.add(
          log.copyWith(
            id: await txn.insert(
              getDatabaseTable(DatabaseTablesEnum.log),
              log.toMap(),
              conflictAlgorithm: ConflictAlgorithm.fail,
            ),
          ),
        );
      }
    });
    return logs;
  }
}
