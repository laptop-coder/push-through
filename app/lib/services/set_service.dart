import 'package:push_through/services/database_service.dart';
import 'package:push_through/models/set.dart';

class SetService {
  static Future<void> create(int workoutId, int weight, int repetitions) async {
    await DatabaseService.insert('sets', {
      'workout_id': workoutId,
      'weight': weight,
      'repetitions': repetitions,
    });
  }

  static Future<List<Set>> getAll(int workoutId) async {
    final maps = await DatabaseService.query(
      'sets',
      whereKey: 'workout_id',
      whereValue: workoutId.toString(),
    );
    return [
      for (final map in maps)
        Set(
          id: map['id'] as int,
          createdAt: map['created_at'] as String,
          updatedAt: map['updated_at'] as String,
          workoutId: map['workout_id'] as int,
          weight: map['weight'] as int,
          repetitions: map['repetitions'] as int,
        ),
    ];
  }

  static Future<void> update(Set set) async {
    await DatabaseService.update('sets', set.toMap(), set.id);
  }

  static Future<void> delete(int id) async {
    await DatabaseService.delete('sets', id);
  }
}
