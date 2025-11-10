import 'package:equatable/equatable.dart';

class Set extends Equatable {
  final int? id;
  final int exerciseId;
  final int? logId;
  final int reps;
  final double kgs;

  const Set({
    this.id,
    required this.exerciseId,
    this.logId,
    required this.reps,
    required this.kgs,
  });

  factory Set.fromJson(Map<String, dynamic> json) => Set(
    id: json['id'],
    exerciseId: json['exerciseId'],
    logId: json['logId'],
    reps: json['reps'],
    kgs: json['kgs'],
  );

  factory Set.empty({
    required int exerciseId,
    int reps = 1,
    double kgs = 5.0,
  }) => Set(exerciseId: exerciseId, reps: reps, kgs: kgs);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'exercise_id': exerciseId,
      'log_id': logId,
      'reps': reps,
      'kgs': kgs,
    };
  }

  @override
  String toString() {
    return 'Set { id: $id, exerciseId: $exerciseId, logId: $logId, reps: $reps, kgs: $kgs }';
  }

  @override
  List<Object?> get props => [id, exerciseId, logId, reps, kgs];

  Set copyWith({
    int? id,
    int? exerciseId,
    int? logId,
    int? reps,
    double? kgs,
  }) => Set(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    logId: logId ?? this.logId,
    reps: reps ?? this.reps,
    kgs: kgs ?? this.kgs,
  );
}
