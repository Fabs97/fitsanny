import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/repositories/training_repository.dart';
import 'package:fitsanny/model/training.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'training_event.dart';
part 'training_state.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final TrainingRepository _trainingRepository;

  TrainingBloc({required TrainingRepository repository})
    : _trainingRepository = repository,
      super(TrainingInitial([])) {
    on<LoadTrainingEvent>((event, emit) async {
      try {
        final trainings = await _trainingRepository.getTrainings();
        emit(TrainingLoaded(trainings));
      } catch (e) {
        emit(TrainingError('Failed to load trainings: $e'));
      }
    });
    on<AddTrainingEvent>((event, emit) async {
      if (state is TrainingLoaded) {
        try {
          await _trainingRepository.insertTraining(event.training);
          final trainings = await _trainingRepository.getTrainings();
          emit(TrainingLoaded(trainings));
        } catch (e) {
          print(e); //TODO - Snackbar
        }
      }
    });
  }
}

extension TrainingProvider on TrainingBloc {
  static BlocProvider<TrainingBloc> get provider => BlocProvider<TrainingBloc>(
    create: (context) {
      final databaseCubit = context.read<DatabaseBloc>();
      if (databaseCubit.database == null) {
        throw StateError('Database not initialized');
      }
      return TrainingBloc(
        repository: TrainingRepository(databaseCubit.database!),
      );
    },
  );
}
