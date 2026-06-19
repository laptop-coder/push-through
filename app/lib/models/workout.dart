import 'package:push_through/services/database_service.dart';

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

  Future<void> insertWorkout(Workout workout) async {
    await DatabaseService.insert('workouts', workout.toMap());
  }

  Future<List<Workout>> workouts() async {
    return [
      for (final {
            'id': id as int,
            'created_at': createdAt as String,
            'updated_at': updatedAt as String,
          }
          in await DatabaseService.query('workouts'))
        Workout(id: id, createdAt: createdAt, updatedAt: updatedAt),
    ];
  }

  Future<void> updateWorkout(Workout workout) async {
    await DatabaseService.update('workouts', workout.toMap(), workout.id);
  }

  Future<void> deleteWorkout(int id) async {
    await DatabaseService.delete('workouts', id);
  }
}
