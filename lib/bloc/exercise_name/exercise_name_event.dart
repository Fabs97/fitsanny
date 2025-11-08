part of 'exercise_name_bloc.dart';

abstract class ExerciseNameEvent extends Equatable {
  const ExerciseNameEvent();

  @override
  List<Object?> get props => [];
}

class LoadExerciseNamesEvent extends ExerciseNameEvent {}

class AddExerciseNameEvent extends ExerciseNameEvent {
  final String name;

  const AddExerciseNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class RemoveExerciseNameEvent extends ExerciseNameEvent {
  final String name;

  const RemoveExerciseNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}
