part of 'training_bloc.dart';

abstract class TrainingEvent extends Equatable {
  final void Function(bool success)? onComplete;
  const TrainingEvent({this.onComplete});

  @override
  List<Object> get props => [];
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
