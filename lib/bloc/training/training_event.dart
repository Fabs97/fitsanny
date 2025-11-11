part of 'training_bloc.dart';

abstract class TrainingEvent extends Equatable {
  final void Function(bool success)? onComplete;
  const TrainingEvent({this.onComplete});

  @override
  List<Object> get props => [onComplete != null];
}

//Event Designed for READING The Elements
class LoadTrainingsEvent extends TrainingEvent {}

class NewTrainingEvent extends TrainingEvent {
  const NewTrainingEvent();
}

//Event Designed for CREATING New Elements
class AddTrainingEvent extends TrainingEvent {
  final Training training;
  const AddTrainingEvent(this.training, {super.onComplete});

  @override
  List<Object> get props => [training];
}

//Event Designed for DELETING The Elements
class RemoveTrainingEvent extends TrainingEvent {
  final int id;
  const RemoveTrainingEvent(this.id, {super.onComplete});

  @override
  List<Object> get props => [id];
}

//Event Designed for UPDATING The Elements
class EditTrainingEvent extends TrainingEvent {
  final Training training;
  const EditTrainingEvent(this.training);

  @override
  List<Object> get props => [training];
}

class AddExerciseToNewTrainingEvent extends TrainingEvent {
  final Exercise exercise;
  const AddExerciseToNewTrainingEvent({this.exercise = const Exercise.empty()});

  @override
  List<Object> get props => [exercise];
}

class ChangeExerciseInNewTrainingEvent extends TrainingEvent {
  final int index;
  final int exerciseNameId;
  const ChangeExerciseInNewTrainingEvent({
    required this.index,
    required this.exerciseNameId,
  });

  @override
  List<Object> get props => [index, exerciseNameId];
}
