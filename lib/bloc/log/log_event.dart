part of "log_bloc.dart";

abstract class LogEvent extends Equatable {
  final void Function(bool success, {Object? data})? onComplete;
  const LogEvent({this.onComplete});

  @override
  List<Object> get props => [onComplete != null];
}

class LoadLogsEvent extends LogEvent {
  final int trainingId;
  const LoadLogsEvent(this.trainingId, {super.onComplete});

  @override
  List<Object> get props => [trainingId, ...super.props];
}

class AddLogEvent extends LogEvent {
  final Log log;
  const AddLogEvent(this.log, {super.onComplete});

  @override
  List<Object> get props => [log, ...super.props];
}

class AddLogsEvent extends LogEvent {
  final List<Log> logs;
  const AddLogsEvent(this.logs, {super.onComplete});

  @override
  List<Object> get props => [logs, ...super.props];
}
