part of 'database_bloc.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object> get props => [];
}

//Event Designed for INITIALIZING The Database
class InitializeDatabaseEvent extends DatabaseEvent {}

//Event Designed for CLOSING The Database
class CloseDatabaseEvent extends DatabaseEvent {}

// Event Designed for LOADING The Database
class LoadDatabaseEvent extends DatabaseEvent {}
