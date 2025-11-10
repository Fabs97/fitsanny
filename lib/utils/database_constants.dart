enum DatabaseTablesEnum {
  training,
  exerciseName,
  exercise,
  trainingExercise,
  log,
  set,
}

String getDatabaseTable(DatabaseTablesEnum table) {
  switch (table) {
    case DatabaseTablesEnum.training:
      return "training";
    case DatabaseTablesEnum.exerciseName:
      return "exercise_name";
    case DatabaseTablesEnum.exercise:
      return "exercise";
    case DatabaseTablesEnum.trainingExercise:
      return "training_exercises";
    case DatabaseTablesEnum.log:
      return 'log';
    case DatabaseTablesEnum.set:
      return 'sets';
  }
}

List<String> baseExercises = [
  // Upper body
  'Bench Press',
  'Incline Bench Press',
  'Overhead Press',
  'Push Up',
  'Pull Up',
  'Chin Up',
  'Barbell Row',
  'Dumbbell Row',
  'Lat Pulldown',
  'Bicep Curl',
  'Tricep Extension',
  'Lateral Raise',

  // Lower body
  'Squat',
  'Front Squat',
  'Deadlift',
  'Romanian Deadlift',
  'Leg Press',
  'Lunge',
  'Calf Raise',
  'Hip Thrust',

  // Core
  'Plank',
  'Crunch',
  'Hanging Leg Raise',
  'Russian Twist',
];
