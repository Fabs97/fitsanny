import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/bloc/goal/goal_cubit.dart';
import 'package:fitsanny/repositories/goal_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalProvider {
  static BlocProvider<GoalCubit> get provider => BlocProvider<GoalCubit>(
    create: (context) {
      final databaseCubit = BlocProvider.of<DatabaseCubit>(context);
      return GoalCubit(GoalRepository(databaseCubit.database!));
    },
  );
}
