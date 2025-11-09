part of 'logger_bloc.dart';

class LoggerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChooseTraining extends LoggerEvent {
  final Training training;
  ChooseTraining({required this.training});

  @override
  List<Object?> get props => [training];
}
