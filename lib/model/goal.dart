import 'package:equatable/equatable.dart';

enum GoalType { reps, weight }

class Goal extends Equatable {
  final int? id;
  final int exerciseId;
  final int reps;
  final double kgs;
  final GoalType type;

  const Goal({
    this.id,
    required this.exerciseId,
    required this.reps,
    required this.kgs,
    this.type = GoalType.weight,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      exerciseId: json['exercise_id'],
      reps: json['reps'],
      kgs: json['kgs'],
      type: GoalType.values.firstWhere(
        (e) => e.name == (json['target_type'] ?? 'weight'),
        orElse: () => GoalType.weight,
      ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'exercise_id': exerciseId,
      'reps': reps,
      'kgs': kgs,
      'target_type': type.name,
    };
  }

  @override
  String toString() {
    return 'Goal { id: $id, exerciseId: $exerciseId, reps: $reps, kgs: $kgs, type: $type }';
  }

  @override
  List<Object?> get props => [id, exerciseId, reps, kgs, type];

  Goal copyWith({
    int? id,
    int? exerciseId,
    int? reps,
    double? kgs,
    GoalType? type,
  }) => Goal(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    reps: reps ?? this.reps,
    kgs: kgs ?? this.kgs,
    type: type ?? this.type,
  );
}
