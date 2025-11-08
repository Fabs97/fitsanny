import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/model/exercise_name.dart';
import 'package:fitsanny/repositories/exercise_name_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'exercise_name_event.dart';
part 'exercise_name_state.dart';

class ExerciseNameBloc extends Bloc<ExerciseNameEvent, ExerciseNamesState> {
  final ExerciseNameRepository _exerciseNameRepository;

  ExerciseNameBloc({required ExerciseNameRepository repository})
    : _exerciseNameRepository = repository,
      super(ExerciseNamesInitial()) {
    on<LoadExerciseNamesEvent>(_loadExerciseNames);
    on<AddExerciseNameEvent>((event, emit) async {
      if (state is! ExerciseNamesLoaded) {
        emit(ExerciseNamesError('Exercise names not loaded'));
      } else {
        await _exerciseNameRepository.addExerciseName(event.name);
        _loadExerciseNames(event, emit);
      }
    });
  }
  void _loadExerciseNames(event, emit) async {
    final exerciseNames = await _exerciseNameRepository.getExerciseNames();
    emit(ExerciseNamesLoaded(exerciseNames));
  }
}

extension ExerciseNamesProvider on ExerciseNameBloc {
  static BlocProvider<ExerciseNameBloc> get provider =>
      BlocProvider<ExerciseNameBloc>(
        create: (context) {
          final databaseCubit = context.read<DatabaseBloc>();
          if (databaseCubit.database == null) {
            throw StateError('Database not initialized');
          }
          return ExerciseNameBloc(
            repository: ExerciseNameRepository(databaseCubit.database!),
          );
        },
      );
}
