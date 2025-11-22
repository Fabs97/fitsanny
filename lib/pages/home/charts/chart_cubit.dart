import 'package:fitsanny/pages/home/charts/chart_data.dart';
import 'package:fitsanny/pages/home/charts/chart_state.dart';
import 'package:fitsanny/repositories/exercise_name_repository.dart';
import 'package:fitsanny/repositories/goal_repository.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartCubit extends Cubit<ChartState> {
  final GoalRepository _goalRepository;
  final LogRepository _logRepository;
  final ExerciseNameRepository _exerciseNameRepository;

  ChartCubit({
    required GoalRepository goalRepository,
    required LogRepository logRepository,
    required ExerciseNameRepository exerciseNameRepository,
  }) : _goalRepository = goalRepository,
       _logRepository = logRepository,
       _exerciseNameRepository = exerciseNameRepository,
       super(ChartsLoading());

  Future<void> loadCharts() async {
    emit(ChartsLoading());
    try {
      final goals = await _goalRepository.getGoals();
      final List<ChartData> chartDataList = [];

      for (final goal in goals) {
        final latestSet = await _logRepository.getLatestSetForExercise(
          goal.exerciseId,
        );
        final exerciseNameObj = await _exerciseNameRepository.getExerciseName(
          goal.exerciseId,
        );
        final exerciseName = exerciseNameObj?.name ?? 'Unknown Exercise';

        chartDataList.add(
          ChartData(
            goal: goal,
            latestSet: latestSet,
            exerciseName: exerciseName,
          ),
        );
      }

      emit(ChartsLoaded(chartDataList));
    } catch (e) {
      emit(ChartError(e.toString()));
    }
  }
}
