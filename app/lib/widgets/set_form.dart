import 'package:flutter/material.dart';
import 'package:push_through/models/set.dart';

class SetForm extends StatefulWidget {
  final Set? set;
  const SetForm({super.key, this.set});

  @override
  State<SetForm> createState() => _SetFormState();
}

class _SetFormState extends State<SetForm> {
  late TextEditingController _weightController;
  late TextEditingController _repetitionsController;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
    _repetitionsController = TextEditingController();
    if (widget.set != null) {
      _weightController.text = widget.set!.weight.toString();
      _repetitionsController.text = widget.set!.repetitions.toString();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repetitionsController.dispose();
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Вес (кг)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _repetitionsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Повторения',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
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
                        final weight = double.tryParse(_weightController.text);
                        final repetitions = int.tryParse(
                          _repetitionsController.text,
                        );
                        if (weight != null && repetitions != null) {
                          Navigator.pop(context, {
                            'weight': weight,
                            'repetitions': repetitions,
                          });
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
