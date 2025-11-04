class Exercise {
  final int id;
  final int name;
  final int reps;

  const Exercise({required this.id, required this.name, required this.reps});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'reps': reps};
  }

  @override
  String toString() {
    return 'Exercise { id: $id, name: $name, reps: $reps }';
  }
}
