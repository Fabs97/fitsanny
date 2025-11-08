import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/model/exercise.dart';
import 'package:fitsanny/repositories/training_repository.dart';
import 'package:fitsanny/model/training.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'training_event.dart';
part 'training_state.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final TrainingRepository _trainingRepository;

  TrainingBloc({required TrainingRepository repository})
    : _trainingRepository = repository,
      super(TrainingsInitial()) {
    on<LoadTrainingsEvent>((event, emit) async {
      try {
        final trainings = await _trainingRepository.getTrainings();
        emit(TrainingsLoaded(trainings));
      } catch (e) {
        emit(TrainingsError('Failed to load trainings: $e'));
      }
    });
    on<NewTrainingEvent>((event, emit) {
      emit(NewTraining());
    });
    on<AddTrainingEvent>((event, emit) async {
      if (state is NewTraining) {
        try {
          await _trainingRepository.insertTraining(event.training);
          final trainings = await _trainingRepository.getTrainings();
          emit(TrainingsLoaded(trainings));
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
