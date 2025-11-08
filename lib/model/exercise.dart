import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int? id;
  final int exerciseNameId;
  final int reps;
  final double kgs;

  const Exercise({
    this.id,
    required this.exerciseNameId,
    required this.reps,
    required this.kgs,
  });

  const Exercise.empty() : id = null, exerciseNameId = 0, reps = 1, kgs = 5.0;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'exerciseNameId': exerciseNameId,
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

  Exercise copyWith({int? exerciseNameId, int? reps, double? kgs}) => Exercise(
    exerciseNameId: exerciseNameId ?? this.exerciseNameId,
    reps: reps ?? this.reps,
    kgs: kgs ?? this.kgs,
  );
}
