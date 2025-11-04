import 'package:fitsanny/app.dart';
import 'package:fitsanny/database/app_database_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppDatabaseCubit>(create: (_) => AppDatabaseCubit()),
      ],
      child: App(),
    );
  }
}
