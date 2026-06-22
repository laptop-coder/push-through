import 'package:flutter/material.dart';
import 'package:push_through/services/database_service.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key, required this.title});
  final String title;

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  void _exportToCSV() async {
    final dir = await getApplicationDocumentsDirectory();

    final currentDateTime = DateTime.now();
    final currentDateTimeFilenames = DateFormat(
      'yyyy-MM-dd-HH-mm',
    ).format(currentDateTime);
    final currentDateTimeText = DateFormat(
      'dd.MM.yyyy HH:mm',
    ).format(currentDateTime);

    final workoutsFile = File(
      '${dir.path}/${currentDateTimeFilenames}_workouts.csv',
    );
    final workoutsCSV = await DatabaseService.exportToCSV('workouts');
    await workoutsFile.writeAsString(workoutsCSV);

    final workoutTypesFile = File(
      '${dir.path}/${currentDateTimeFilenames}_workout_types.csv',
    );
    final workoutTypesCSV = await DatabaseService.exportToCSV('workout_types');
    await workoutTypesFile.writeAsString(workoutTypesCSV);

    final setsFile = File('${dir.path}/${currentDateTimeFilenames}_sets.csv');
    final setsCSV = await DatabaseService.exportToCSV('sets');
    await setsFile.writeAsString(setsCSV);

    final readmeFile = File(
      '${dir.path}/${currentDateTimeFilenames}_README.md',
    );
    final exportMessage =
        'Экспорт от $currentDateTimeText\nПолные пути к файлам:\n1. ${workoutsFile.path}\n2. ${workoutTypesFile.path}\n3. ${setsFile.path}';
    await readmeFile.writeAsString(exportMessage);

    if (Platform.isLinux) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Сохранено в ${dir.path}')));
      }
      Process.run('xdg-open', [dir.path]);
    } else {
      await SharePlus.instance.share(
        ShareParams(
          text: exportMessage,
          files: [
            XFile(workoutsFile.path),
            XFile(workoutTypesFile.path),
            XFile(setsFile.path),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        child: Text('Скачать в CSV'),
        onPressed: () => _exportToCSV(),
      ),
    );
  }
}
