import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int? id;
  final int exerciseNameId;
  final String? exerciseName;
  final int reps;
  final double kgs;

  const Exercise({
    this.id,
    this.exerciseName,
    required this.exerciseNameId,
    required this.reps,
    required this.kgs,
  });

  const Exercise.empty()
    : id = null,
      exerciseNameId = 0,
      reps = 1,
      kgs = 5.0,
      exerciseName = null;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      exerciseNameId: json['exercise_name_id'],
      exerciseName: json['name'],
      reps: json['reps'],
      kgs: json['kgs'],
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'exercise_name_id': exerciseNameId,
      'reps': reps,
      'kgs': kgs,
    };
  }

  @override
  String toString() {
    return 'Exercise { id: $id, exerciseNameId: $exerciseNameId, reps: $reps, kgs: $kgs }';
  }

  @override
  List<Object?> get props => [id, exerciseNameId, reps, kgs];

  Exercise copyWith({int? id, int? exerciseNameId, int? reps, double? kgs}) =>
      Exercise(
        id: id ?? this.id,
        exerciseNameId: exerciseNameId ?? this.exerciseNameId,
        reps: reps ?? this.reps,
        kgs: kgs ?? this.kgs,
      );
}
