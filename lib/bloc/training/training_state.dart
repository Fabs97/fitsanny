part of 'training_bloc.dart';

class TrainingState extends Equatable {
  final List<Training> trainings;
  const TrainingState(this.trainings);

  @override
  List<Object> get props => [trainings];
}

class TrainingsInitial extends TrainingState {
  const TrainingsInitial(super.trainings);
}

class TrainingsLoading extends TrainingState {
  const TrainingsLoading(super.trainings);
}

class TrainingsLoaded extends TrainingState {
  const TrainingsLoaded(super.trainings);
}

class NewTraining extends TrainingState {
  final List<ExerciseRow> exerciseRows = [ExerciseRow()];

  NewTraining(super.trainings);
}

class TrainingsError extends TrainingState {
  final String message;
  const TrainingsError(this.message) : super(const []);
}
