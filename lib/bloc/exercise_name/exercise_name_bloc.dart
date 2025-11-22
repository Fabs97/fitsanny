import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_bloc.dart';
import 'package:fitsanny/model/exercise_name.dart';
import 'package:fitsanny/repositories/exercise_name_repository.dart';
import 'package:fitsanny/services/file_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'exercise_name_event.dart';
part 'exercise_name_state.dart';

class ExerciseNameBloc extends Bloc<ExerciseNameEvent, ExerciseNamesState> {
  final ExerciseNameRepository _exerciseNameRepository;
  final FileService _fileService;
  final DatabaseBloc _databaseBloc;

  ExerciseNameBloc({
    required ExerciseNameRepository repository,
    required FileService fileService,
    required DatabaseBloc databaseBloc,
  }) : _exerciseNameRepository = repository,
       _fileService = fileService,
       _databaseBloc = databaseBloc,
       super(ExerciseNamesInitial()) {
    on<LoadExerciseNamesEvent>((event, emit) async {
      final exerciseNames = await _exerciseNameRepository.getExerciseNames();
      emit(ExerciseNamesLoaded(exerciseNames));
    });
    on<AddExerciseNameEvent>((event, emit) async {
      try {
        // Add the new exercise name and get inserted id
        final insertedId = await _exerciseNameRepository.addExerciseName(
          event.name,
        );

        // Immediately fetch the updated list and emit new state
        final exerciseNames = await _exerciseNameRepository.getExerciseNames();
        emit(ExerciseNamesLoaded(exerciseNames));

        // Notify caller about the newly created id
        event.onComplete?.call(insertedId);

        // Trigger backup
        _fileService.backupDatabase(await _databaseBloc.databasePath);
      } catch (e) {
        emit(ExerciseNamesError('Failed to add exercise name: $e'));
      }
    });
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
            fileService: FileService(),
            databaseBloc: databaseCubit,
          );
        },
      );
}
