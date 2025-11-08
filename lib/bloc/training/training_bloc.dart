import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/repositories/training_repository.dart';
import 'package:fitsanny/model/training.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'training_event.dart';
part 'training_state.dart';

class TrainingCubit extends Bloc<TrainingEvent, TrainingState> {
  final TrainingRepository _trainingRepository;

  TrainingCubit({required TrainingRepository repository})
    : _trainingRepository = repository,
      super(TrainingInitial([])) {
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
          )..add(LoadTrainingEvent());
        },
      );
}
