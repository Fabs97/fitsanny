import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/model/exercise.dart';
import 'package:fitsanny/repositories/training_repository.dart';
import 'package:fitsanny/model/training.dart';
import 'package:fitsanny/services/file_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'training_state.dart';

class TrainingCubit extends Cubit<TrainingState> {
  final TrainingRepository _trainingRepository;
  final FileService _fileService;
  final DatabaseCubit _databaseCubit;

  TrainingCubit({
    required TrainingRepository repository,
    required FileService fileService,
    required DatabaseCubit databaseCubit,
  }) : _trainingRepository = repository,
       _fileService = fileService,
       _databaseCubit = databaseCubit,
       super(TrainingsInitial());

  Future<void> loadTrainings() async {
    try {
      final trainings = await _trainingRepository.getTrainings();
      emit(TrainingsLoaded(trainings));
    } catch (e) {
      emit(TrainingsError('Failed to load trainings: $e'));
    }
  }

  void startNewTraining(Training training) {
    emit(NewTraining(training: training));
  }

  Future<void> addTraining(
    Training training, {
    Function(bool)? onComplete,
  }) async {
    if (state is NewTraining) {
      try {
        await _trainingRepository.insertTraining(training);
        final trainings = await _trainingRepository.getTrainings();
        emit(TrainingsLoaded(trainings));
        onComplete?.call(true);

        // Trigger backup
        _fileService.backupDatabase(await _databaseCubit.databasePath);
      } catch (e) {
        onComplete?.call(false);
        print(e); //TODO - Snackbar
      }
    }
  }

  Future<void> removeTraining(int id) async {
    try {
      await _trainingRepository.deleteTraining(id);
      final trainings = await _trainingRepository.getTrainings();
      emit(TrainingsLoaded(trainings));

      // Trigger backup
      _fileService.backupDatabase(await _databaseCubit.databasePath);
    } catch (e) {
      print(e); //TODO - Snackbar
    }
  }

  Future<void> updateTraining(
    Training training, {
    Function(bool)? onComplete,
  }) async {
    try {
      await _trainingRepository.updateTraining(training);
      final trainings = await _trainingRepository.getTrainings();
      emit(TrainingsLoaded(trainings));
      onComplete?.call(true);

      // Trigger backup
      _fileService.backupDatabase(await _databaseCubit.databasePath);
    } catch (e) {
      onComplete?.call(false);
      print(e); //TODO - Snackbar
    }
  }

  void addExerciseToNewTraining(Exercise exercise) {
    if (state is NewTraining) {
      final currentState = state as NewTraining;
      // Create a new list with the added exercise to ensure state equality is updated
      final updatedExercises = [
        ...currentState.newTraining.exercises,
        exercise,
      ];
      final updatedTraining = currentState.newTraining.copyWith(
        exercises: updatedExercises,
      );
      // Emit a new NewTraining state to trigger rebuild and preserve form state
      emit(NewTraining(training: updatedTraining));
    }
  }

  void changeExerciseInNewTraining(int index, int exerciseNameId) {
    if (state is NewTraining) {
      final currentState = state as NewTraining;
      final updatedExercises = [...currentState.newTraining.exercises];
      if (index >= 0 && index < updatedExercises.length) {
        updatedExercises[index] = updatedExercises[index].copyWith(
          exerciseNameId: exerciseNameId,
        );
        final updatedTraining = currentState.newTraining.copyWith(
          exercises: updatedExercises,
        );
        emit(NewTraining(training: updatedTraining));
      }
    }
  }
}

extension TrainingProvider on TrainingCubit {
  static BlocProvider<TrainingCubit> get provider =>
      BlocProvider<TrainingCubit>(
        create: (context) {
          final databaseCubit = context.read<DatabaseCubit>();
          if (databaseCubit.database == null) {
            throw StateError('Database not initialized');
          }
          return TrainingCubit(
            repository: TrainingRepository(databaseCubit.database!),
            fileService: FileService(),
            databaseCubit: databaseCubit,
          );
        },
      );
}
