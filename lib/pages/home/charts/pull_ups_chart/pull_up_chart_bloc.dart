import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pull_up_chart_event.dart';
part 'pull_up_chart_state.dart';

class PullUpChartBloc extends Bloc<PullUpChartEvent, PullUpChartState> {
  final LogRepository _logRepository;

  PullUpChartBloc({required LogRepository repository})
    : _logRepository = repository,
      super(LogInitial()) {
    on<LoadLogsForPullUpChart>((event, emit) async {
      try {
        emit(LogsLoading());
        final logs = await _logRepository.getLogsBetween(
          event.startTime,
          event.endTime,
          exerciseName: 'pull ups',
        );
        emit(LogsLoaded(logs));
        event.onComplete?.call(true);
      } catch (e) {
        event.onComplete?.call(false);
        emit(LogError('Failed to load logs with time range'));
      }
    });
  }
}

extension PullUpChartBlocProvider on PullUpChartBloc {
  static BlocProvider<PullUpChartBloc> get provider =>
      BlocProvider<PullUpChartBloc>(
        create: (context) {
          final databaseCubit = context.read<DatabaseBloc>();
          if (databaseCubit.database == null) {
            throw StateError('Database not initialized');
          }
          return PullUpChartBloc(
            repository: LogRepository(databaseCubit.database!),
          );
        },
      );
}
