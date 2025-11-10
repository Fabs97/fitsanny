part of 'pull_up_chart_bloc.dart';

class PullUpChartState extends Equatable {
  const PullUpChartState();

  @override
  List<Object> get props => [];
}

class LogInitial extends PullUpChartState {}

class LogsLoading extends PullUpChartState {}

class LogsLoaded extends PullUpChartState {
  final List<Log> logs;

  const LogsLoaded(this.logs);

  @override
  List<Object> get props => [logs];
}

class LogError extends PullUpChartState {
  final String message;
  const LogError(this.message) : super();

  @override
  List<Object> get props => [message, ...super.props];
}
