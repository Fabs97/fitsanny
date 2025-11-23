import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fitsanny/model/set.dart';

class Log extends Equatable {
  final int? id;
  final int trainingId;
  final List<Set> sets;
  final DateTime? createdAt;
  final String? trainingName;

  const Log({
    this.id,
    required this.trainingId,
    required this.sets,
    this.createdAt,
    this.trainingName,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    id: json['id'],
    trainingId: json['training_id'],
    sets: jsonDecode(json['sets'] ?? []),
    createdAt: DateTime.tryParse(json['created_at']),
    trainingName: json['training_name'],
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'training_id': trainingId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Log { id: $id, trainingId: $trainingId, trainingName: $trainingName, sets: [ ${sets.map((s) => s.toMap()).join(', ')} ], createdAt: ${createdAt.toString()}}';
  }

  @override
  List<Object?> get props => [id, trainingId, sets, createdAt, trainingName];

  Log copyWith({
    int? id,
    int? trainingId,
    List<Set>? sets,
    DateTime? createdAt,
    String? trainingName,
  }) => Log(
    id: id ?? this.id,
    trainingId: trainingId ?? this.trainingId,
    sets: sets ?? this.sets,
    createdAt: createdAt ?? this.createdAt,
    trainingName: trainingName ?? this.trainingName,
  );
}
