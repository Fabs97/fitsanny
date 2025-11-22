import 'package:bloc/bloc.dart';
import 'package:fitsanny/bloc/goal/goal_state.dart';
import 'package:fitsanny/repositories/goal_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalCubit extends Cubit<GoalState> {
  final GoalRepository _goalRepository;

  GoalCubit(this._goalRepository) : super(GoalsLoading());

  Future<void> loadGoals() async {
    emit(GoalsLoading());
    try {
      final goals = await _goalRepository.getGoals();
      emit(GoalsLoaded(goals));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> addGoal(goal) async {
    try {
      await _goalRepository.insertGoal(goal);
      await loadGoals();
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> updateGoal(goal) async {
    try {
      await _goalRepository.updateGoal(goal);
      await loadGoals();
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> deleteGoal(int id) async {
    try {
      await _goalRepository.deleteGoal(id);
      await loadGoals();
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }
}
