import 'package:push_through/services/database_service.dart';
import 'package:push_through/models/workout.dart';

class WorkoutService {
  static Future<void> create(Workout workout) async {
    await DatabaseService.insert('workouts', workout.toMap());
  }

  static Future<List<Workout>> read() async {
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

  static Future<void> update(Workout workout) async {
    await DatabaseService.update('workouts', workout.toMap(), workout.id);
  }

  static Future<void> delete(int id) async {
    await DatabaseService.delete('workouts', id);
  }
}
