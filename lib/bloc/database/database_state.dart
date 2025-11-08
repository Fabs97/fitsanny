import 'package:equatable/equatable.dart';

sealed class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object> get props => [];
}

final class InitialDatabaseState extends DatabaseState {}

final class LoadedDatabaseState extends DatabaseState {}
