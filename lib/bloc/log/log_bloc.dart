import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:fitsanny/services/file_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_event.dart';
part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final LogRepository _logRepository;
  final FileService _fileService;
  final DatabaseBloc _databaseBloc;

  LogBloc({
    required LogRepository repository,
    required FileService fileService,
    required DatabaseBloc databaseBloc,
  }) : _logRepository = repository,
       _fileService = fileService,
       _databaseBloc = databaseBloc,
       super(LogInitial()) {
    on<LoadLogsTimeSpanEvent>((event, emit) async {
      try {
        emit(LogsLoading());
        final logs = await _logRepository.getLogsBetween(
          event.startTime,
          event.endTime,
        );
        emit(LogsLoaded(logs));
        event.onComplete?.call(true);
      } catch (e) {
        print(e);
        event.onComplete?.call(false);
        emit(LogError('Failed to load logs with time range'));
      }
    });
    on<LoadLogsEvent>((event, emit) async {
      try {
        emit(LogsLoading());
        final logs = await _logRepository.getLatestLogsForTraining(
          event.trainingId,
        );
        emit(LogsLoaded(logs));
        event.onComplete?.call(true);
      } catch (e) {
        event.onComplete?.call(false);
        emit(
          LogError('Failed to load logs for trainingId: ${event.trainingId}'),
        );
      }
    });
    on<AddLogsEvent>((event, emit) async {
      try {
        emit(LogsLoading());

        final newLogs = await _logRepository.insertLogs(event.logs);
        emit(LogsLoaded(newLogs));
        event.onComplete?.call(true, data: newLogs);

        // Trigger backup
        _fileService.backupDatabase(await _databaseBloc.databasePath);
      } catch (e) {
        event.onComplete?.call(false);
        emit(
          LogError(
            'Failed to add logs ${event.logs.map((l) => l.toString())}}',
          ),
        );
      }
    });
  }
}

extension LogProvider on LogBloc {
  static BlocProvider<LogBloc> get provider => BlocProvider<LogBloc>(
    create: (context) {
      final databaseBloc = context.read<DatabaseBloc>();
      if (databaseBloc.database == null) {
        throw StateError('Database not initialized');
      }
      return LogBloc(
        repository: LogRepository(databaseBloc.database!),
        fileService: FileService(),
        databaseBloc: databaseBloc,
      );
    },
  );
}
