class ExerciseName {
  final int id;
  final String name;

  const ExerciseName({required this.id, required this.name});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'ExerciseName { id: $id, name: $name }';
  }
}
