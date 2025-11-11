part of 'muscle_up_chart_bloc.dart';

class MuscleUpChartState extends Equatable {
  const MuscleUpChartState();

  @override
  List<Object> get props => [];
}

class LogInitial extends MuscleUpChartState {}

class LogsLoading extends MuscleUpChartState {}

class LogsLoaded extends MuscleUpChartState {
  final List<Log> logs;

  const LogsLoaded(this.logs);

  @override
  List<Object> get props => [logs];
}

class LogError extends MuscleUpChartState {
  final String message;
  const LogError(this.message) : super();

  @override
  List<Object> get props => [message, ...super.props];
}
