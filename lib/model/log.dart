import 'package:equatable/equatable.dart';

class Log extends Equatable {
  final int? id;
  final int trainingId;
  final int exerciseId;
  final int reps;
  final double kgs;
  final DateTime? createdAt;

  const Log({
    this.id,
    required this.trainingId,
    required this.exerciseId,
    required this.reps,
    required this.kgs,
    required this.createdAt,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    id: json['id'],
    trainingId: json['training_id'],
    exerciseId: json['exercise_id'],
    reps: json['reps'],
    kgs: json['kgs'],
    createdAt: DateTime.tryParse(json['created_at']),
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'training_id': trainingId,
      'exercise_id': exerciseId,
      'reps': reps,
      'kgs': kgs,
      'created_at': createdAt.toString(),
    };
  }

  @override
  String toString() {
    return 'Log { id: $id, trainingId: $trainingId, exerciseId: $exerciseId, reps: $reps, kgs: $kgs, createdAt: ${createdAt.toString()}}';
  }

  @override
  List<Object?> get props => [id, trainingId, exerciseId, reps, kgs, createdAt];

  Log copyWith({
    int? id,
    int? trainingId,
    int? exerciseId,
    int? reps,
    double? kgs,
    DateTime? createdAt,
  }) => Log(
    id: id ?? this.id,
    trainingId: trainingId ?? this.trainingId,
    exerciseId: exerciseId ?? this.exerciseId,
    reps: reps ?? this.reps,
    kgs: kgs ?? this.kgs,
    createdAt: createdAt ?? this.createdAt,
  );
}
