import 'package:push_through/services/database_service.dart';
import 'package:push_through/models/workout.dart';

class WorkoutService {
  static Future<int> create(int exerciseId) async {
    return await DatabaseService.insert('workouts', {
      'exercise_id': exerciseId,
    });
  }

  static Future<List<Workout>> getAll(int exerciseId) async {
    return [
      for (final {
            'id': id as int,
            'created_at': createdAt as String,
            'updated_at': updatedAt as String,
            'exercise_id': exerciseId as int,
          }
          in await DatabaseService.query(
            'workouts',
            orderBy: 'created_at DESC',
            whereKey: 'exercise_id',
            whereValue: exerciseId.toString(),
          ))
        Workout(
          id: id,
          createdAt: DateTime.parse(
            '${createdAt.replaceAll(' ', 'T')}Z',
          ).toLocal().toString(),
          updatedAt: DateTime.parse(
            '${updatedAt.replaceAll(' ', 'T')}Z',
          ).toLocal().toString(),
          exerciseId: exerciseId,
        ),
    ];
  }

  static Future<Workout> getById(int id) async {
    final workout = await DatabaseService.query(
      'workouts',
      whereKey: 'id',
      whereValue: id.toString(),
    );
    return Workout(
      id: workout[0]['id'] as int,
      createdAt: DateTime.parse(
        '${(workout[0]['created_at'] as String).replaceAll(' ', 'T')}Z',
      ).toLocal().toString(),
      updatedAt: DateTime.parse(
        '${(workout[0]['updated_at'] as String).replaceAll(' ', 'T')}Z',
      ).toLocal().toString(),
      exerciseId: workout[0]['exercise_id'] as int,
    );
  }

  static Future<void> update(Workout workout) async {
    await DatabaseService.update('workouts', workout.toMap(), workout.id);
  }

  static Future<void> delete(int id) async {
    await DatabaseService.delete('workouts', id);
  }
}
