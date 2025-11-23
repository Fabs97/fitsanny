import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:fitsanny/services/file_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_state.dart';

class LogCubit extends Cubit<LogState> {
  final LogRepository _logRepository;
  final FileService _fileService;
  final DatabaseCubit _databaseCubit;

  // Track the last filter used to load logs
  Map<String, dynamic>? _lastFilter;

  LogCubit({
    required LogRepository repository,
    required FileService fileService,
    required DatabaseCubit databaseCubit,
  }) : _logRepository = repository,
       _fileService = fileService,
       _databaseCubit = databaseCubit,
       super(LogInitial());

  Future<void> loadLogsTimeSpan(
    DateTime start,
    DateTime end, {
    Function(bool, {dynamic data})? onComplete,
  }) async {
    _lastFilter = {'type': 'timeSpan', 'start': start, 'end': end};
    await _reload(onComplete: onComplete);
  }

  Future<void> loadLogs(
    int trainingId, {
    Function(bool, {dynamic data})? onComplete,
  }) async {
    _lastFilter = {'type': 'training', 'id': trainingId};
    await _reload(onComplete: onComplete);
  }

  Future<void> _reload({Function(bool, {dynamic data})? onComplete}) async {
    if (_lastFilter == null) return;

    try {
      emit(LogsLoading());
      List<Log> logs = [];

      if (_lastFilter!['type'] == 'timeSpan') {
        logs = await _logRepository.getLogsBetween(
          _lastFilter!['start'],
          _lastFilter!['end'],
        );
      } else if (_lastFilter!['type'] == 'training') {
        logs = await _logRepository.getLatestLogsForTraining(
          _lastFilter!['id'],
        );
      }

      emit(LogsLoaded(logs));
      onComplete?.call(true);
    } catch (e) {
      print(e);
      onComplete?.call(false);
      emit(LogError('Failed to load logs'));
    }
  }

  Future<void> addLogs(
    List<Log> logs, {
    Function(bool, {dynamic data})? onComplete,
  }) async {
    try {
      emit(LogsLoading());

      final newLogs = await _logRepository.insertLogs(logs);

      // Reload the current view instead of just emitting new logs
      await _reload();

      onComplete?.call(true, data: newLogs);

      // Trigger backup
      _fileService.backupDatabase(await _databaseCubit.databasePath);
    } catch (e) {
      onComplete?.call(false);
      emit(LogError('Failed to add logs ${logs.map((l) => l.toString())}}'));
    }
  }

  Future<void> updateLog(
    Log log, {
    Function(bool, {dynamic data})? onComplete,
  }) async {
    try {
      emit(LogsLoading());
      await _logRepository.updateLog(log);

      // Reload the current view
      await _reload();

      onComplete?.call(true);
      _fileService.backupDatabase(await _databaseCubit.databasePath);
    } catch (e) {
      onComplete?.call(false);
      emit(LogError('Failed to update log: $e'));
    }
  }

  Future<Log?> getLatestLog(int trainingId) async {
    try {
      final logs = await _logRepository.getLatestLogsForTraining(trainingId);
      if (logs.isNotEmpty) {
        return logs.first;
      }
    } catch (e) {
      print('Failed to get latest log for training $trainingId: $e');
    }
    return null;
  }
}

extension LogProvider on LogCubit {
  static BlocProvider<LogCubit> get provider => BlocProvider<LogCubit>(
    create: (context) {
      final databaseCubit = context.read<DatabaseCubit>();
      if (databaseCubit.database == null) {
        throw StateError('Database not initialized');
      }
      return LogCubit(
        repository: LogRepository(databaseCubit.database!),
        fileService: FileService(),
        databaseCubit: databaseCubit,
      );
    },
  );
}
