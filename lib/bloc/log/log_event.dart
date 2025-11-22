part of "log_bloc.dart";

abstract class LogEvent extends Equatable {
  final void Function(bool success, {Object? data})? onComplete;
  const LogEvent({this.onComplete});

  @override
  List<Object> get props => [onComplete != null];
}

class LoadLogsTimeSpanEvent extends LogEvent {
  late final DateTime startTime;
  late final DateTime endTime;

  LoadLogsTimeSpanEvent({super.onComplete, DateTime? start, DateTime? end}) {
    endTime = end ?? DateTime.now();
    startTime = start ?? endTime.subtract(Duration(days: 7));
  }
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

class UpdateLogEvent extends LogEvent {
  final Log log;
  const UpdateLogEvent(this.log, {super.onComplete});

  @override
  List<Object> get props => [log, ...super.props];
}
