import 'package:fitsanny/app.dart';
import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/bloc/exercise_name/exercise_name_cubit.dart';
import 'package:fitsanny/bloc/goal/goal_provider.dart';
import 'package:fitsanny/bloc/log/log_cubit.dart';
import 'package:fitsanny/bloc/training/training_cubit.dart';
import 'package:fitsanny/bloc/settings/settings_cubit.dart';
import 'package:fitsanny/pages/logger/logger_cubit.dart';
import 'package:fitsanny/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PermissionAwareApp());
}

/// Wrapper that handles app lifecycle and permission changes
class PermissionAwareApp extends StatefulWidget {
  const PermissionAwareApp({super.key});

  @override
  State<PermissionAwareApp> createState() => _PermissionAwareAppState();
}

class _PermissionAwareAppState extends State<PermissionAwareApp>
    with WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isCheckingPermission = true;
  final FileService _fileService = FileService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app resumes (e.g., returning from settings), recheck permissions
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    if (!Platform.isAndroid) {
      setState(() {
        _hasPermission = true;
        _isCheckingPermission = false;
      });
      return;
    }

    final hasPermission = await _fileService.requestStoragePermission();
    setState(() {
      _hasPermission = hasPermission;
      _isCheckingPermission = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermission) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Checking permissions...'),
              ],
            ),
          ),
        ),
      );
    }

    if (!_hasPermission && Platform.isAndroid) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: Colors.grey),
                  SizedBox(height: 24),
                  Text(
                    'Storage Permission Required',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'FitSanny needs storage permission to backup and restore your workout data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      await _fileService.openStorageSettings();
                    },
                    child: Text('Grant Permission'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const MyApp();
  }
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
                BlocProvider(
                  create: (context) => SettingsCubit()..loadSettings(),
                ),
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
