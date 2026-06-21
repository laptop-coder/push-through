class Set {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int workoutId;
  final int weight;
  final int repetitions;

  Set({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.workoutId,
    required this.weight,
    required this.repetitions,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'workout_id': workoutId,
      'weight': weight,
      'repetitions': repetitions,
    };
  }

  @override
  String toString() {
    return 'Set{id: $id, created_at: $createdAt, updated_at: $updatedAt, workout_id: $workoutId, weight: $weight, repetitions: $repetitions}';
  }
}
