final String createExerciseNameTableQuery = '''
CREATE TABLE exercise_name(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE
)
''';

final String createExerciseTableQuery = '''
CREATE TABLE exercise(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  exercise_name_id INTEGER,
  sets INTEGER,
  reps INTEGER,
  kgs REAL,
  FOREIGN KEY(exercise_name_id) REFERENCES exercise_name(id)
)
''';

final String createTrainingTableQuery = '''
CREATE TABLE training(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT
)
''';
final String createTrainingExercisesTableQuery = '''
CREATE TABLE training_exercises(
  training_id INTEGER,
  exercise_id INTEGER,
  FOREIGN KEY(training_id) REFERENCES training(id),
  FOREIGN KEY(exercise_id) REFERENCES exercise(id)
)
''';
