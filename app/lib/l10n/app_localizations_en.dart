// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitleFull => 'Push Through! Workouts';

  @override
  String get cancel => 'Cancel';

  @override
  String get dataImportExport => 'Data import/export';

  @override
  String get delete => 'Delete';

  @override
  String get exerciseName => 'Exercise name';

  @override
  String get exportTo => 'Export to';

  @override
  String get exportedTo => 'Exported to';

  @override
  String get importFrom => 'Import from';

  @override
  String get importedSuccessfully => 'Imported successfully';

  @override
  String get newExercise => 'New exercise';

  @override
  String get newSet => 'New set';

  @override
  String get newWorkout => 'New workout';

  @override
  String get noExercises => 'No exercises yet';

  @override
  String get noSets => 'No sets yet';

  @override
  String get noWorkouts => 'No workouts yet';

  @override
  String repetition(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'repetitions',
      one: 'repetition',
    );
    return '$_temp0';
  }

  @override
  String get repetitions => 'Repetitions';

  @override
  String get save => 'Save';

  @override
  String get set => 'set';

  @override
  String get weight => 'Weight';

  @override
  String get weightUnit => 'lb';

  @override
  String get workouts => 'Workouts';
}
