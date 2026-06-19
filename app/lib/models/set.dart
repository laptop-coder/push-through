import 'package:push_through/services/database_service.dart';

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

  Future<void> insertSet(Set set) async {
    await DatabaseService.insert('sets', set.toMap());
  }

  Future<List<Set>> sets() async {
    return [
      for (final {
            'id': id as int,
            'created_at': createdAt as String,
            'updated_at': updatedAt as String,
            'workout_id': workoutId as int,
            'weight': weight as int,
            'repetitions': repetitions as int,
          }
          in await DatabaseService.query('sets'))
        Set(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          workoutId: workoutId,
          weight: weight,
          repetitions: repetitions,
        ),
    ];
  }

  Future<void> updateSet(Set set) async {
    await DatabaseService.update('sets', set.toMap(), set.id);
  }

  Future<void> deleteSet(int id) async {
    await DatabaseService.delete('sets', id);
  }
}
