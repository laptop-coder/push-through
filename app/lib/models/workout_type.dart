class WorkoutType {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String name;

  WorkoutType({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  Map<String, Object?> toMap() {
    return {'id': id, 'created_at': createdAt, 'updated_at': updatedAt, 'name': name};
  }

  @override
  String toString() {
    return 'WorkoutType{id: $id, created_at: $createdAt, updated_at: $updatedAt, name: $name}';
  }
}
