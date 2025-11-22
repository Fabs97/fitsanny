import 'package:equatable/equatable.dart';
import 'package:fitsanny/model/exercise.dart';

class Training extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final List<Exercise> exercises;

  const Training({
    this.id,
    required this.title,
    this.description,
    required this.exercises,
  });

  factory Training.fromJson(Map<String, dynamic> json) => Training(
    title: json['title'],
    description: json['description'],
    exercises: json['exercises'],
  );

  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'description': description};
  }

  @override
  String toString() {
    return 'Training { id: $id, title: $title, description: $description, exercises: [${exercises.map((e) => e.toString()).join(", ")}] }';
  }

  @override
  List<Object?> get props => [id, title, description, exercises];

  Training copyWith({
    int? id,
    String? title,
    String? description,
    List<Exercise>? exercises,
  }) {
    return Training(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
    );
  }
}
