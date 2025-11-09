part of 'exercise_name_bloc.dart';

abstract class ExerciseNameEvent extends Equatable {
  const ExerciseNameEvent();

  @override
  List<Object?> get props => [];
}

class LoadExerciseNamesEvent extends ExerciseNameEvent {
  final List<int> ids;

  const LoadExerciseNamesEvent({this.ids = const <int>[]});

  @override
  List<Object?> get props => [ids];
}

class LoadedExerciseNamesEvent extends ExerciseNameEvent {
  final List<ExerciseName> names;

  const LoadedExerciseNamesEvent({required this.names});

  @override
  List<Object?> get props => [names];
}

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
