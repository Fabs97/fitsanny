import 'package:fitsanny/utils/database_constants.dart';

final String createExerciseNameTableQuery =
    '''
CREATE TABLE ${getDatabaseTable(DatabaseTablesEnum.exerciseName)}(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE
)
''';

final String createExerciseTableQuery =
    '''
CREATE TABLE ${getDatabaseTable(DatabaseTablesEnum.exercise)}(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  exercise_name_id INTEGER,
  reps INTEGER,
  kgs REAL,
  FOREIGN KEY(exercise_name_id) REFERENCES exercise_name(id)
)
''';

final String createTrainingTableQuery =
    '''
CREATE TABLE ${getDatabaseTable(DatabaseTablesEnum.training)}(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT
)
''';
final String createTrainingExercisesTableQuery =
    '''
CREATE TABLE ${getDatabaseTable(DatabaseTablesEnum.trainingExercise)}(
  training_id INTEGER,
  exercise_id INTEGER,
  FOREIGN KEY(training_id) REFERENCES training(id),
  FOREIGN KEY(exercise_id) REFERENCES exercise(id)
)
''';
final String createLoggerTableQuery =
    '''
CREATAE TABLE ${getDatabaseTable(DatabaseTablesEnum.log)}(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  training_id INTEGER,
  exercise_id INTEGER,
  reps INTEGER,
  kgs REAL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY(training_id) REFERENCES training(id),
  FOREIGN KEY(exercise_id) REFERENCES exercise(id)
)
''';
