part of "pull_up_chart_bloc.dart";

abstract class PullUpChartEvent extends Equatable {
  final void Function(bool success, {Object? data})? onComplete;
  const PullUpChartEvent({this.onComplete});

  @override
  List<Object> get props => [onComplete != null];
}

class LoadLogsForPullUpChart extends PullUpChartEvent {
  late final DateTime startTime;
  late final DateTime endTime;

  LoadLogsForPullUpChart({super.onComplete, DateTime? start, DateTime? end}) {
    endTime = end ?? DateTime.now();
    startTime = start ?? endTime.subtract(Duration(days: 7));
  }
}
