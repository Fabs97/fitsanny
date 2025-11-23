import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/model/set.dart';

List<Log> fromLogsWithSetMapToFlutterClasses(List<Map<String, Object?>> rows) {
  final Map<int, Log> logsMap = {};
  for (final row in rows) {
    final int logId = row['log_id'] as int;
    if (logsMap.keys.contains(logId)) {
      // add another set
      final Log log = logsMap[logId]!;
      logsMap[logId] = log.copyWith(
        sets: [
          ...log.sets,
          Set(
            id: row['set_id'] as int,
            exerciseId: row['set_exercise_id'] as int,
            logId: logId,
            reps: row['set_reps'] as int,
            kgs: row['set_kgs'] as double,
          ),
        ],
      );
    } else {
      logsMap[logId] = Log(
        id: logId,
        trainingId: row['training_id'] as int,
        trainingName: row['training_name'] as String?,
        createdAt: DateTime.tryParse(row['created_at'] as String),
        sets: [
          Set(
            id: row['set_id'] as int,
            exerciseId: row['set_exercise_id'] as int,
            logId: logId,
            reps: row['set_reps'] as int,
            kgs: row['set_kgs'] as double,
          ),
        ],
      );
    }
  }

  return logsMap.values.toList();
}
