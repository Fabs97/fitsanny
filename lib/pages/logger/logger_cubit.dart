import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/model/training.dart';
import 'package:fitsanny/repositories/training_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logger_state.dart';

class LoggerCubit extends Cubit<LoggerState> {
  final TrainingRepository? _trainingRepository;

  LoggerCubit({TrainingRepository? trainingRepository})
    : _trainingRepository = trainingRepository,
      super(UnchosenTraining());

  void chooseTraining(Training training) {
    emit(ChosenTraining(training: training));
  }

  Future<void> loadTraining(int trainingId) async {
    if (_trainingRepository != null) {
      final training = await _trainingRepository.getTraining(trainingId);
      if (training != null) {
        emit(ChosenTraining(training: training));
      }
    }
  }
}

extension LoggerProvider on LoggerCubit {
  static BlocProvider<LoggerCubit> get provider => BlocProvider<LoggerCubit>(
    create: (context) {
      final databaseCubit = BlocProvider.of<DatabaseCubit>(context);
      // We might need to handle the case where database is not ready yet,
      // but usually it is by the time we reach here.
      // If database is null, we can't create repository.
      // But LoggerCubit is provided at root.
      // We can pass null if db is not ready, but then loadTraining won't work.
      // However, loadTraining is only called when editing a log, which implies DB is ready.
      if (databaseCubit.database != null) {
        return LoggerCubit(
          trainingRepository: TrainingRepository(databaseCubit.database!),
        );
      }
      return LoggerCubit();
    },
  );
}
