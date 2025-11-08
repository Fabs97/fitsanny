part of 'database_bloc.dart';

sealed class DatabaseState extends Equatable {
  final Database? database;
  const DatabaseState(this.database);

  @override
  List<Object> get props => [];
}

final class InitialDatabaseState extends DatabaseState {
  const InitialDatabaseState() : super(null);
}

final class LoadedDatabaseState extends DatabaseState {
  const LoadedDatabaseState(super.database);
}

final class ClosedDatabaseState extends DatabaseState {
  const ClosedDatabaseState() : super(null);
}

final class ErrorDatabaseState extends DatabaseState {
  final String message;
  const ErrorDatabaseState(this.message, {Database? database})
    : super(database);

  @override
  List<Object> get props => [message];
}
