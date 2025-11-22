import 'package:equatable/equatable.dart';
import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/model/exercise_name.dart';
import 'package:fitsanny/repositories/exercise_name_repository.dart';
import 'package:fitsanny/services/file_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'exercise_name_state.dart';

class ExerciseNameCubit extends Cubit<ExerciseNamesState> {
  final ExerciseNameRepository _exerciseNameRepository;
  final FileService _fileService;
  final DatabaseCubit _databaseCubit;

  ExerciseNameCubit({
    required ExerciseNameRepository repository,
    required FileService fileService,
    required DatabaseCubit databaseCubit,
  }) : _exerciseNameRepository = repository,
       _fileService = fileService,
       _databaseCubit = databaseCubit,
       super(ExerciseNamesInitial());

  Future<void> loadExerciseNames() async {
    final exerciseNames = await _exerciseNameRepository.getExerciseNames();
    emit(ExerciseNamesLoaded(exerciseNames));
  }

  Future<void> addExerciseName(String name, {Function(int)? onComplete}) async {
    try {
      // Add the new exercise name and get inserted id
      final insertedId = await _exerciseNameRepository.addExerciseName(name);

      // Immediately fetch the updated list and emit new state
      final exerciseNames = await _exerciseNameRepository.getExerciseNames();
      emit(ExerciseNamesLoaded(exerciseNames));

      // Notify caller about the newly created id
      onComplete?.call(insertedId);

      // Trigger backup
      _fileService.backupDatabase(await _databaseCubit.databasePath);
    } catch (e) {
      emit(ExerciseNamesError('Failed to add exercise name: $e'));
    }
  }
}

extension ExerciseNamesProvider on ExerciseNameCubit {
  static BlocProvider<ExerciseNameCubit> get provider =>
      BlocProvider<ExerciseNameCubit>(
        create: (context) {
          final databaseCubit = context.read<DatabaseCubit>();
          if (databaseCubit.database == null) {
            throw StateError('Database not initialized');
          }
          return ExerciseNameCubit(
            repository: ExerciseNameRepository(databaseCubit.database!),
            fileService: FileService(),
            databaseCubit: databaseCubit,
          );
        },
      );
}
