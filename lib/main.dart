import 'package:fitsanny/app.dart';
import 'package:fitsanny/bloc/database/database_cubit.dart';
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
    return MultiBlocProvider(
      providers: [DatabaseProvider.provider, TrainingProvider.provider],
      child: App(),
    );
  }
}
