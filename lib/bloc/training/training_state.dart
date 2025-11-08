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
  final Training newTraining = Training(
    title: 'New Training',
    exercises: [Exercise.empty()],
  );

  NewTraining();

  void addExercise({Exercise exercise = const Exercise.empty()}) {
    newTraining.exercises.add(exercise);
  }

  void changeExercise(int index, int exerciseNameId) {
    // copyWith returns a new Exercise instance; assign it back to persist the change
    newTraining.exercises[index] = newTraining.exercises[index].copyWith(
      exerciseNameId: exerciseNameId,
    );
  }
}

class TrainingsError extends TrainingState {
  final String message;
  const TrainingsError(this.message) : super();
}
