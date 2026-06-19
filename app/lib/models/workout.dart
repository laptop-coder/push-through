class Workout {
  final int id;
  final String createdAt;
  final String updatedAt;

  Workout({required this.id, required this.createdAt, required this.updatedAt});

  Map<String, Object?> toMap() {
    return {'id': id, 'created_at': createdAt, 'updated_at': updatedAt};
  }

  @override
  String toString() {
    return 'Workout{id: $id, created_at: $createdAt, updated_at: $updatedAt}';
  }
}
