import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'muscle_up_chart_event.dart';
part 'muscle_up_chart_state.dart';

class MuscleUpChartBloc extends Bloc<MuscleUpChartEvent, MuscleUpChartState> {
  final LogRepository _logRepository;

  MuscleUpChartBloc({required LogRepository repository})
    : _logRepository = repository,
      super(LogInitial()) {
    on<LoadLogsForMuscleUpChart>((event, emit) async {
      try {
        emit(LogsLoading());
        final logs = await _logRepository.getLogsBetween(
          event.startTime,
          event.endTime,
          exerciseName: 'Muscle Up',
          limit: 5,
        );
        emit(LogsLoaded(logs));
        event.onComplete?.call(true, data: logs);
      } catch (e) {
        event.onComplete?.call(false);
        emit(LogError('Failed to load logs with time range'));
      }
    });
  }
}

extension MuscleUpChartBlocProvider on MuscleUpChartBloc {
  static BlocProvider<MuscleUpChartBloc> get provider =>
      BlocProvider<MuscleUpChartBloc>(
        create: (context) {
          final databaseCubit = context.read<DatabaseBloc>();
          if (databaseCubit.database == null) {
            throw StateError('Database not initialized');
          }
          return MuscleUpChartBloc(
            repository: LogRepository(databaseCubit.database!),
          );
        },
      );
}
