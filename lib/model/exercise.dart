class Exercise {
  final int id;
  final String name;
  final int reps;
  final double kgs;

  const Exercise({
    required this.id,
    required this.name,
    required this.reps,
    required this.kgs,
  });

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'reps': reps, 'kgs': kgs};
  }

  @override
  String toString() {
    return 'Exercise { id: $id, name: $name, reps: $reps, kgs: $kgs }';
  }
}
