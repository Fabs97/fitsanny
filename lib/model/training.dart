import 'package:fitsanny/model/exercise.dart';

class Training {
  final int id;
  final String title;
  final List<Exercise> exercises;

  const Training({
    required this.id,
    required this.title,
    required this.exercises,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Training { id: $id, title: $title, exercises: [${exercises.map((e) => e.toString()).join(", ")}] }';
  }
}
