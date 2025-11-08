import 'package:equatable/equatable.dart';
import 'package:fitsanny/model/exercise.dart';

class Training extends Equatable {
  final int? id;
  final String title;
  final List<Exercise> exercises;

  const Training({this.id, required this.title, required this.exercises});

  factory Training.fromJson(Map<String, dynamic> json) =>
      Training(title: json['title'], exercises: json['exercises']);

  Map<String, Object?> toMap() {
    return {'id': id, 'title': title};
  }

  @override
  String toString() {
    return 'Training { id: $id, title: $title, exercises: [${exercises.map((e) => e.toString()).join(", ")}] }';
  }

  @override
  List<Object?> get props => [id, title, exercises];

  Training copyWith({int? id, String? title, List<Exercise>? exercises}) {
    return Training(
      id: id ?? this.id,
      title: title ?? this.title,
      exercises: exercises ?? this.exercises,
    );
  }
}
