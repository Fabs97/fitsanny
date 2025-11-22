part of 'logger_bloc.dart';

class LoggerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChooseTraining extends LoggerEvent {
  final Training training;

  ChooseTraining(this.training);

  @override
  List<Object> get props => [training];
}

class LoadTraining extends LoggerEvent {
  final int trainingId;

  LoadTraining(this.trainingId);

  @override
  List<Object> get props => [trainingId];
}
