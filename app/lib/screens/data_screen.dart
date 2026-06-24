import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:push_through/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'dart:io';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key, required this.title});
  final String title;

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  void _exportDBToZip(List<String> tables) async {
    final dir = await getApplicationDocumentsDirectory();
    final encoder = ZipEncoder();
    final archive = Archive();

    for (final table in tables) {
      final csv = await DatabaseService.exportTableToCSV(table);
      archive.addFile(ArchiveFile('$table.csv', csv.length, csv.codeUnits));
    }

    final currentDateTime = DateTime.now();
    final currentDateTimeFilenames = DateFormat(
      'yyyy-MM-dd-HH-mm',
    ).format(currentDateTime);
    final pathToZip =
        '${dir.path}/${currentDateTimeFilenames}_export_push-through.zip';
    final zipFile = File(pathToZip);

    await zipFile.writeAsBytes(encoder.encode(archive));

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Экспортировано в $pathToZip')));
    }
  }

  void _importDBFromZip(File zipFile) async {
    final tmpDir = Directory.systemTemp.createTempSync('push_through_import_');
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final table in ['workout_types', 'workouts', 'sets']) {
      final file = archive.findFile('$table.csv');
      if (file != null) {
        final content = String.fromCharCodes(file.content);
        final tmpFile = File('${tmpDir.path}/${file.name}');
        await tmpFile.writeAsString(content);
        await DatabaseService.importTableFromCSV(table, tmpFile);
        await tmpFile.delete();
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Успешно импортировано')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            child: Text('Экспортировать в ZIP'),
            onPressed: () =>
                _exportDBToZip(['workout_types', 'workouts', 'sets']),
          ),
          SizedBox(height: 10),
          FilledButton(
            child: Text('Импортировать из ZIP'),
            onPressed: () async {
              final result = await FilePicker.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['zip'],
              );

              if (result != null && result.files.single.path != null) {
                final file = File(result.files.single.path!);
                _importDBFromZip(file);
              }
            },
          ),
        ],
      ),
    );
  }
}
