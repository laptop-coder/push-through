import 'package:push_through/services/database_service.dart';
import 'package:push_through/models/workout_type.dart';

class WorkoutTypeService {
  static Future<int> create(String name) async {
    return await DatabaseService.insert('workout_types', {'name': name});
  }

  static Future<List<WorkoutType>> getAll() async {
    return [
      for (final {
            'id': id as int,
            'created_at': createdAt as String,
            'updated_at': updatedAt as String,
            'name': name as String,
          }
          in await DatabaseService.query(
            'workout_types',
            orderBy: 'name',
          ))
        WorkoutType(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          name: name,
        ),
    ];
  }

  static Future<WorkoutType> getById(int id) async {
    final workout = await DatabaseService.query(
      'workout_types',
      whereKey: 'id',
      whereValue: id.toString(),
    );
    return WorkoutType(
      id: workout[0]['id'] as int,
      createdAt: workout[0]['created_at'] as String,
      updatedAt: workout[0]['updated_at'] as String,
      name: workout[0]['name'] as String,
    );
  }

  static Future<void> update(WorkoutType workoutType) async {
    await DatabaseService.update(
      'workout_types',
      workoutType.toMap(),
      workoutType.id,
    );
  }

  static Future<void> delete(int id) async {
    await DatabaseService.delete('workout_types', id);
  }
}
