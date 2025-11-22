import 'package:equatable/equatable.dart';
import 'package:fitsanny/model/goal.dart';
import 'package:fitsanny/model/set.dart';

class ChartData extends Equatable {
  final Goal goal;
  final Set? latestSet;
  final String exerciseName;

  const ChartData({
    required this.goal,
    this.latestSet,
    required this.exerciseName,
  });

  @override
  List<Object?> get props => [goal, latestSet, exerciseName];
}
