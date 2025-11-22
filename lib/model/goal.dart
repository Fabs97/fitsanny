import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final int? id;
  final int exerciseId;
  final int reps;
  final double kgs;

  const Goal({
    this.id,
    required this.exerciseId,
    required this.reps,
    required this.kgs,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      exerciseId: json['exercise_id'],
      reps: json['reps'],
      kgs: json['kgs'],
    );
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'exercise_id': exerciseId, 'reps': reps, 'kgs': kgs};
  }

  @override
  String toString() {
    return 'Goal { id: $id, exerciseId: $exerciseId, reps: $reps, kgs: $kgs }';
  }

  @override
  List<Object?> get props => [id, exerciseId, reps, kgs];

  Goal copyWith({int? id, int? exerciseId, int? reps, double? kgs}) => Goal(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    reps: reps ?? this.reps,
    kgs: kgs ?? this.kgs,
  );
}
