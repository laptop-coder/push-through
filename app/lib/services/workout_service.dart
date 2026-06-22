import 'package:push_through/services/database_service.dart';
import 'package:push_through/models/workout.dart';

class WorkoutService {
  static Future<int> create(int workoutTypeId) async {
    return await DatabaseService.insert('workouts', {'type_id': workoutTypeId});
  }

  static Future<List<Workout>> getAll(int workoutTypeId) async {
    return [
      for (final {
            'id': id as int,
            'created_at': createdAt as String,
            'updated_at': updatedAt as String,
            'type_id': typeId as int,
          }
          in await DatabaseService.query(
            'workouts',
            orderBy: 'created_at DESC',
            whereKey: 'type_id',
            whereValue: workoutTypeId.toString(),
          ))
        Workout(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          typeId: typeId,
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
      createdAt: workout[0]['created_at'] as String,
      updatedAt: workout[0]['updated_at'] as String,
      typeId: workout[0]['type_id'] as int,
    );
  }

  static Future<void> update(Workout workout) async {
    await DatabaseService.update('workouts', workout.toMap(), workout.id);
  }

  static Future<void> delete(int id) async {
    await DatabaseService.delete('workouts', id);
  }
}
