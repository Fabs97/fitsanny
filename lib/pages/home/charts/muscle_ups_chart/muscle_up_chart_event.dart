part of "muscle_up_chart_bloc.dart";

abstract class MuscleUpChartEvent extends Equatable {
  final void Function(bool success, {Object? data})? onComplete;
  const MuscleUpChartEvent({this.onComplete});

  @override
  List<Object> get props => [onComplete != null];
}

class LoadLogsForMuscleUpChart extends MuscleUpChartEvent {
  late final DateTime startTime;
  late final DateTime endTime;

  LoadLogsForMuscleUpChart({super.onComplete, DateTime? start, DateTime? end}) {
    endTime = end ?? DateTime.now();
    startTime = start ?? endTime.subtract(Duration(days: 7));
  }
}
