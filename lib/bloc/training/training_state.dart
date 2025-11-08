part of 'training_bloc.dart';

class TrainingState extends Equatable {
  final List<Training> trainings;
  const TrainingState(this.trainings);

  @override
  List<Object> get props => [trainings];
}

class TrainingInitial extends TrainingState {
  const TrainingInitial(super.trainings);
}

class TrainingLoading extends TrainingState {
  const TrainingLoading(super.trainings);
}

class TrainingLoaded extends TrainingState {
  const TrainingLoaded(super.trainings);
}

class TrainingError extends TrainingState {
  final String message;
  const TrainingError(this.message) : super(const []);
}
