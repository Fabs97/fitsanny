import 'package:fitsanny/model/exercise.dart';

class ExerciseDto {
  final int id;
  final int? exerciseNameId;
  final String exerciseName;
  final int reps;
  final double kgs;

  ExerciseDto({
    required this.id,
    required this.exerciseName,
    required this.reps,
    required this.kgs,
    this.exerciseNameId,
  });

  ExerciseDto copyWith({required int exerciseNameId}) {
    return ExerciseDto(
      id: id,
      exerciseNameId: exerciseNameId,
      exerciseName: exerciseName,
      reps: reps,
      kgs: kgs,
    );
  }

  Exercise toExercise() {
    return Exercise(
      id: id,
      exerciseNameId: exerciseNameId!,
      reps: reps,
      kgs: kgs,
    );
  }
}
