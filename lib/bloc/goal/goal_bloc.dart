import 'package:bloc/bloc.dart';
import 'package:fitsanny/bloc/goal/goal_event.dart';
import 'package:fitsanny/bloc/goal/goal_state.dart';
import 'package:fitsanny/repositories/goal_repository.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GoalRepository _goalRepository;

  GoalBloc(this._goalRepository) : super(GoalsLoading()) {
    on<LoadGoals>(_onLoadGoals);
    on<AddGoal>(_onAddGoal);
    on<UpdateGoal>(_onUpdateGoal);
    on<DeleteGoal>(_onDeleteGoal);
  }

  Future<void> _onLoadGoals(LoadGoals event, Emitter<GoalState> emit) async {
    emit(GoalsLoading());
    try {
      final goals = await _goalRepository.getGoals();
      emit(GoalsLoaded(goals));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> _onAddGoal(AddGoal event, Emitter<GoalState> emit) async {
    try {
      await _goalRepository.insertGoal(event.goal);
      add(LoadGoals());
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> _onUpdateGoal(UpdateGoal event, Emitter<GoalState> emit) async {
    try {
      await _goalRepository.updateGoal(event.goal);
      add(LoadGoals());
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> _onDeleteGoal(DeleteGoal event, Emitter<GoalState> emit) async {
    try {
      await _goalRepository.deleteGoal(event.id);
      add(LoadGoals());
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }
}
