import 'package:push_through/services/database_service.dart';
import 'package:push_through/models/set.dart';

class SetService {
  static Future<void> create(Set set) async {
    await DatabaseService.insert('sets', set.toMap());
  }

  static Future<List<Set>> read() async {
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

  static Future<void> update(Set set) async {
    await DatabaseService.update('sets', set.toMap(), set.id);
  }

  static Future<void> delete(int id) async {
    await DatabaseService.delete('sets', id);
  }
}
