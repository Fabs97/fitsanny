import 'package:equatable/equatable.dart';

class ExerciseName extends Equatable {
  final int id;
  final String name;

  const ExerciseName({required this.id, required this.name});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name};
  }

  factory ExerciseName.fromMap(Map<String, dynamic> map) {
    return ExerciseName(id: map['id'] as int, name: map['name'] as String);
  }

  @override
  String toString() {
    return 'ExerciseName { id: $id, name: $name }';
  }

  @override
  List<Object?> get props => [id, name];
}
