import 'package:equatable/equatable.dart';
import 'package:fitsanny/model/goal.dart';

abstract class GoalState extends Equatable {
  const GoalState();

  @override
  List<Object?> get props => [];
}

class GoalsLoading extends GoalState {}

class GoalsLoaded extends GoalState {
  final List<Goal> goals;

  const GoalsLoaded(this.goals);

  @override
  List<Object?> get props => [goals];
}

class GoalError extends GoalState {
  final String message;

  const GoalError(this.message);

  @override
  List<Object?> get props => [message];
}
