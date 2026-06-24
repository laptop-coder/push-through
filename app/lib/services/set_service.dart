import 'package:flutter/material.dart';
import 'package:push_through/services/database_service.dart';
import 'package:push_through/models/set.dart';
import 'package:push_through/utils/weight_converter.dart';

class SetService {
  static Future<void> create(
    int workoutId,
    double weight,
    int repetitions,
    Locale locale,
  ) async {
    await DatabaseService.insert('sets', {
      'workout_id': workoutId,
      'weight': WeightConverter.toKg(weight, locale),
      'repetitions': repetitions,
    });
  }

  static Future<List<Set>> getAll(int workoutId, Locale locale) async {
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
          weight: WeightConverter.fromKg(map['weight'] as double, locale),
          repetitions: map['repetitions'] as int,
        ),
    ];
  }

  static Future<void> update(Set set, Locale locale) async {
    var setMap = set.toMap();
    setMap['weight'] = WeightConverter.toKg(set.weight, locale);
    await DatabaseService.update('sets', setMap, set.id);
  }

  static Future<void> delete(int id) async {
    await DatabaseService.delete('sets', id);
  }
}
