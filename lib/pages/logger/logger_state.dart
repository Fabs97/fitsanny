part of 'logger_bloc.dart';

class LoggerState extends Equatable {
  final Training? training;

  const LoggerState({required this.training});

  @override
  List<Object?> get props => [training];
}

class UnchosenTraining extends LoggerState {
  const UnchosenTraining() : super(training: null);

  @override
  List<Object?> get props => [...super.props];
}

class ChosenTraining extends LoggerState {
  const ChosenTraining({required Training training})
    : super(training: training);

  @override
  List<Object?> get props => [...super.props];
}
