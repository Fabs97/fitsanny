import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/pages/home/charts/chart_cubit.dart';
import 'package:fitsanny/repositories/exercise_name_repository.dart';
import 'package:fitsanny/repositories/goal_repository.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartProvider {
  static BlocProvider<ChartCubit> get provider => BlocProvider<ChartCubit>(
    create: (context) {
      final databaseCubit = BlocProvider.of<DatabaseCubit>(context);
      final db = databaseCubit.database!;
      return ChartCubit(
        goalRepository: GoalRepository(db),
        logRepository: LogRepository(db),
        exerciseNameRepository: ExerciseNameRepository(db),
      );
    },
  );
}
