import 'package:bloc_test/bloc_test.dart';
import 'package:fitsanny/bloc/database/database_cubit.dart';
import 'package:fitsanny/bloc/log/log_cubit.dart';
import 'package:fitsanny/model/log.dart';
import 'package:fitsanny/repositories/log_repository.dart';
import 'package:fitsanny/services/file_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLogRepository extends Mock implements LogRepository {}

class MockFileService extends Mock implements FileService {}

class MockDatabaseCubit extends Mock implements DatabaseCubit {}

void main() {
  group('LogCubit', () {
    late LogRepository logRepository;
    late FileService fileService;
    late DatabaseCubit databaseCubit;
    late LogCubit logCubit;

    setUp(() {
      registerFallbackValue(DateTime.now());
      registerFallbackValue(Log(id: 0, trainingId: 0, sets: []));

      logRepository = MockLogRepository();
      fileService = MockFileService();
      databaseCubit = MockDatabaseCubit();

      when(
        () => databaseCubit.databasePath,
      ).thenAnswer((_) async => 'path/to/db');
      when(() => fileService.backupDatabase(any())).thenAnswer((_) async {});

      logCubit = LogCubit(
        repository: logRepository,
        fileService: fileService,
        databaseCubit: databaseCubit,
      );
    });

    final log1 = Log(id: 1, trainingId: 1, sets: [], createdAt: DateTime.now());
    final log2 = Log(id: 2, trainingId: 1, sets: [], createdAt: DateTime.now());

    blocTest<LogCubit, LogState>(
      'addLogs reloads the previous time span view',
      build: () {
        when(
          () => logRepository.getLogsBetween(any(), any()),
        ).thenAnswer((_) async => [log1]);
        when(
          () => logRepository.insertLogs(any()),
        ).thenAnswer((_) async => [log2]);
        return logCubit;
      },
      act: (cubit) async {
        // 1. Load initial view
        await cubit.loadLogsTimeSpan(DateTime.now(), DateTime.now());

        // 2. Add new log
        // We expect the repository to be called again for getLogsBetween due to reload
        await cubit.addLogs([log2]);
      },
      verify: (_) {
        // Verify getLogsBetween was called twice (initial load + reload)
        verify(() => logRepository.getLogsBetween(any(), any())).called(2);
      },
    );
  });
}
