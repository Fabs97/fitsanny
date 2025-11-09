import 'package:fitsanny/app.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/bloc/exercise_name/exercise_name_bloc.dart';
import 'package:fitsanny/bloc/log/log_bloc.dart';
import 'package:fitsanny/bloc/training/training_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DatabaseBloc()..add(InitializeDatabaseEvent()),
      child: BlocBuilder<DatabaseBloc, DatabaseState>(
        builder: (context, state) {
          if (state is LoadedDatabaseState) {
            return MultiBlocProvider(
              providers: [
                TrainingProvider.provider,
                ExerciseNamesProvider.provider,
                LogProvider.provider,
              ],
              child: App(),
            );
          } else if (state is ErrorDatabaseState) {
            return MaterialApp(
              home: Scaffold(
                body: Center(child: Text('Error: ${state.message}')),
              ),
            );
          } else {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }
        },
      ),
    );
  }
}
