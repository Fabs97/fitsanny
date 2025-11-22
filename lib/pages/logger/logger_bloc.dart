import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/model/training.dart';
import 'package:fitsanny/repositories/training_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logger_event.dart';
part 'logger_state.dart';

class LoggerBloc extends Bloc<LoggerEvent, LoggerState> {
  final TrainingRepository? _trainingRepository;

  LoggerBloc({TrainingRepository? trainingRepository})
    : _trainingRepository = trainingRepository,
      super(UnchosenTraining()) {
    on<ChooseTraining>((event, emit) async {
      emit(ChosenTraining(training: event.training));
    });
    on<LoadTraining>((event, emit) async {
      if (_trainingRepository != null) {
        final training = await _trainingRepository.getTraining(
          event.trainingId,
        );
        if (training != null) {
          emit(ChosenTraining(training: training));
        }
      }
    });
  }
}

extension LoggerProvider on LoggerBloc {
  static BlocProvider<LoggerBloc> get provider => BlocProvider<LoggerBloc>(
    create: (context) {
      final databaseBloc = BlocProvider.of<DatabaseBloc>(context);
      // We might need to handle the case where database is not ready yet,
      // but usually it is by the time we reach here.
      // If database is null, we can't create repository.
      // But LoggerBloc is provided at root.
      // We can pass null if db is not ready, but then LoadTraining won't work.
      // However, LoadTraining is only called when editing a log, which implies DB is ready.
      if (databaseBloc.database != null) {
        return LoggerBloc(
          trainingRepository: TrainingRepository(databaseBloc.database!),
        );
      }
      return LoggerBloc();
    },
  );
}
