import 'package:flutter/material.dart';
import 'package:push_through/models/workout_type.dart';

class WorkoutTypeForm extends StatefulWidget {
  final WorkoutType? workoutType;
  const WorkoutTypeForm({super.key, this.workoutType});

  @override
  State<WorkoutTypeForm> createState() => _WorkoutTypeFormState();
}

class _WorkoutTypeFormState extends State<WorkoutTypeForm> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    if (widget.workoutType != null) {
      _nameController.text = widget.workoutType!.name.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Название упражнения',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Отмена'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final name = _nameController.text;
                        if (name.isNotEmpty) {
                          Navigator.pop(context, {'name': name});
                        }
                      },
                      child: Text('Сохранить'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
