import 'package:fitsanny/app.dart';
import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/bloc/exercise_name/exercise_name_cubit.dart';
import 'package:fitsanny/bloc/goal/goal_provider.dart';
import 'package:fitsanny/bloc/log/log_cubit.dart';
import 'package:fitsanny/bloc/training/training_cubit.dart';
import 'package:fitsanny/pages/logger/logger_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request storage permission at startup on Android
  if (Platform.isAndroid) {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DatabaseCubit()..initializeDatabase(),
      child: BlocBuilder<DatabaseCubit, DatabaseState>(
        builder: (context, state) {
          if (state is LoadedDatabaseState) {
            return MultiBlocProvider(
              providers: [
                TrainingProvider.provider,
                ExerciseNamesProvider.provider,
                LogProvider.provider,
                // This is a page bloc, shouldn't be here but it's 00.30 and I'm tired
                LoggerProvider.provider,
                GoalProvider.provider,
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
            return MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }
        },
      ),
    );
  }
}
