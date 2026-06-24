import 'package:push_through/services/database_service.dart';
import 'package:push_through/models/exercise.dart';

class ExerciseService {
  static Future<int> create(String name) async {
    return await DatabaseService.insert('exercises', {'name': name});
  }

  static Future<List<Exercise>> getAll() async {
    return [
      for (final {
            'id': id as int,
            'created_at': createdAt as String,
            'updated_at': updatedAt as String,
            'name': name as String,
          }
          in await DatabaseService.query(
            'exercises',
            orderBy: 'name',
          ))
        Exercise(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          name: name,
        ),
    ];
  }

  static Future<Exercise> getById(int id) async {
    final workout = await DatabaseService.query(
      'exercises',
      whereKey: 'id',
      whereValue: id.toString(),
    );
    return Exercise(
      id: workout[0]['id'] as int,
      createdAt: workout[0]['created_at'] as String,
      updatedAt: workout[0]['updated_at'] as String,
      name: workout[0]['name'] as String,
    );
  }

  static Future<void> update(Exercise exercise) async {
    await DatabaseService.update(
      'exercises',
      exercise.toMap(),
      exercise.id,
    );
  }

  static Future<void> delete(int id) async {
    await DatabaseService.delete('exercises', id);
  }
}
