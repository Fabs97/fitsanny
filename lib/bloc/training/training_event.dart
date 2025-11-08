part of 'training_bloc.dart';

abstract class TrainingEvent extends Equatable {
  const TrainingEvent();

  @override
  List<Object> get props => [];
}

//Event Designed for READING The Elements
class LoadTrainingEvent extends TrainingEvent {}

//Event Designed for CREATING New Elements
class AddTrainingEvent extends TrainingEvent {
  final Training training;
  const AddTrainingEvent(this.training);

  @override
  List<Object> get props => [training];
}

//Event Designed for DELETING The Elements
class RemoveTrainingEvent extends TrainingEvent {
  final Training training;
  const RemoveTrainingEvent(this.training);

  @override
  List<Object> get props => [training];
}

//Event Designed for UPDATING The Elements
class EditTrainingEvent extends TrainingEvent {
  final Training training;
  const EditTrainingEvent(this.training);

  @override
  List<Object> get props => [training];
}
