import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/bloc/goal/goal_bloc.dart';
import 'package:fitsanny/repositories/goal_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalProvider {
  static BlocProvider<GoalBloc> get provider => BlocProvider<GoalBloc>(
    create: (context) {
      final databaseBloc = BlocProvider.of<DatabaseBloc>(context);
      return GoalBloc(GoalRepository(databaseBloc.database!));
    },
  );
}
