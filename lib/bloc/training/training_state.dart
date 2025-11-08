part of 'training_bloc.dart';

class TrainingState extends Equatable {
  const TrainingState();

  @override
  List<Object> get props => [];
}

class TrainingsInitial extends TrainingState {}

class TrainingsLoading extends TrainingState {}

class TrainingsLoaded extends TrainingState {
  final List<Training> trainings;

  const TrainingsLoaded(this.trainings);
}

class NewTraining extends TrainingState {
  final List<ExerciseRow> exerciseRows = [ExerciseRow()];

  NewTraining();
}

class TrainingsError extends TrainingState {
  final String message;
  const TrainingsError(this.message) : super();
}
