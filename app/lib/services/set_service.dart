import 'package:push_through/services/database_service.dart';
import 'package:push_through/models/set.dart';

class SetService {
  static Future<void> create(Set set) async {
    await DatabaseService.insert('sets', set.toMap());
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
          createdAt: map['createdAt'] as String,
          updatedAt: map['updatedAt'] as String,
          workoutId: map['workoutId'] as int,
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
