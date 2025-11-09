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

class AddLogsEvent extends LogEvent {
  final Log log;
  const AddLogsEvent(this.log, {super.onComplete});

  @override
  List<Object> get props => [log, ...super.props];
}
