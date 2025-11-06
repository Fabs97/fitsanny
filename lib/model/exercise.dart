class Exercise {
  final int id;
  final int exerciseNameId;
  final int reps;
  final double kgs;

  const Exercise({
    required this.id,
    required this.exerciseNameId,
    required this.reps,
    required this.kgs,
  });

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
}
