import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'log_event.dart';
part 'log_state.dart';

class LogBloc extends Bloc<LogEvent, LogState> {
  final LogRepository _logRepository;

  LogBloc({required LogRepository repository})
    : _logRepository = repository,
      super(LogInitial()) {
    on<LoadLogsEvent>((event, emit) async {
      try {
        emit(LogsLoading());
        final logs = await _logRepository.getLogsForTraining(event.trainingId);
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
        event.onComplete?.call(true, data: newLogs);
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
      final databaseCubit = context.read<DatabaseBloc>();
      if (databaseCubit.database == null) {
        throw StateError('Database not initialized');
      }
      return LogBloc(repository: LogRepository(databaseCubit.database!));
    },
  );
}
