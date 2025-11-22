import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/pages/home/charts/chart_bloc.dart';
import 'package:fitsanny/repositories/exercise_name_repository.dart';
import 'package:fitsanny/repositories/goal_repository.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartProvider {
  static BlocProvider<ChartBloc> get provider => BlocProvider<ChartBloc>(
    create: (context) {
      final databaseBloc = BlocProvider.of<DatabaseBloc>(context);
      final db = databaseBloc.database!;
      return ChartBloc(
        goalRepository: GoalRepository(db),
        logRepository: LogRepository(db),
        exerciseNameRepository: ExerciseNameRepository(db),
      );
    },
  );
}
