part of 'exercise_name_cubit.dart';

class ExerciseNamesState extends Equatable {
  const ExerciseNamesState();

  @override
  List<Object?> get props => [];
}

class ExerciseNamesInitial extends ExerciseNamesState {}

class ExerciseNamesLoaded extends ExerciseNamesState {
  final List<ExerciseName> exerciseNames;

  const ExerciseNamesLoaded(this.exerciseNames);

  @override
  List<Object?> get props => [exerciseNames];
}

class ExerciseNamesError extends ExerciseNamesState {
  final String message;

  const ExerciseNamesError(this.message);

  @override
  List<Object?> get props => [message];
}
