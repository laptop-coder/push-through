class Workout {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int exerciseId;

  Workout({required this.id, required this.createdAt, required this.updatedAt, required this.exerciseId});

  Map<String, Object?> toMap() {
    return {'id': id, 'created_at': createdAt, 'updated_at': updatedAt, 'exercise_id': exerciseId};
  }

  @override
  String toString() {
    return 'Workout{id: $id, created_at: $createdAt, updated_at: $updatedAt, exercise_id: $exerciseId}';
  }
}
