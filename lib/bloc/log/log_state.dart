part of 'log_bloc.dart';

class LogState extends Equatable {
  const LogState();

  @override
  List<Object> get props => [];
}

class LogInitial extends LogState {}

class LogsLoading extends LogState {}

class LogsLoaded extends LogState {
  final List<Log> logs;

  const LogsLoaded(this.logs);

  @override
  List<Object> get props => [logs];
}

class LogError extends LogState {
  final String message;
  const LogError(this.message) : super();

  @override
  List<Object> get props => [message, ...super.props];
}
