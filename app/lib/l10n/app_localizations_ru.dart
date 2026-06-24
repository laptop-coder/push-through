// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitleFull => 'Дожми! Тренировки';

  @override
  String get cancel => 'Отмена';

  @override
  String get dataImportExport => 'Импорт/экспорт данных';

  @override
  String get delete => 'Удалить';

  @override
  String get exerciseName => 'Название упражнения';

  @override
  String get exportTo => 'Экспортировать в';

  @override
  String get exportedTo => 'Экспортировано в';

  @override
  String get importFrom => 'Импортировать из';

  @override
  String get importedSuccessfully => 'Успешно импортировано';

  @override
  String get newExercise => 'Новое упражнение';

  @override
  String get newSet => 'Новый подход';

  @override
  String get newWorkout => 'Новая тренировка';

  @override
  String get noExercises => 'Нет упражнений';

  @override
  String get noSets => 'Нет подходов';

  @override
  String get noWorkouts => 'Нет тренировок';

  @override
  String repetition(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'повторений',
      many: 'повторений',
      few: 'повторения',
      one: 'повторение',
      zero: 'повторений',
    );
    return '$_temp0';
  }

  @override
  String get repetitions => 'Повторения';

  @override
  String get save => 'Сохранить';

  @override
  String get set => 'подход';

  @override
  String get weight => 'Вес';

  @override
  String get weightUnit => 'кг';

  @override
  String get workouts => 'Тренировки';
}
