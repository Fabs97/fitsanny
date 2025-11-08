enum DatabaseTablesEnum { training, exerciseName, exercise, trainingExercise }

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
  }
}
