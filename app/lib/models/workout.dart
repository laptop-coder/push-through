class Workout {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int typeId;

  Workout({required this.id, required this.createdAt, required this.updatedAt, required this.typeId});

  Map<String, Object?> toMap() {
    return {'id': id, 'created_at': createdAt, 'updated_at': updatedAt, 'type_id': typeId};
  }

  @override
  String toString() {
    return 'Workout{id: $id, created_at: $createdAt, updated_at: $updatedAt, type_id: $typeId}';
  }
}
