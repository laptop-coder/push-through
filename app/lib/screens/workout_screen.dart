import 'package:flutter/material.dart';
import 'package:push_through/services/workout_service.dart';
import 'package:push_through/models/set.dart';
import 'package:push_through/models/workout.dart';
import 'package:push_through/services/set_service.dart';
import 'package:push_through/utils/format_datetime.dart';
import 'package:push_through/widgets/set_form.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required this.workoutId});
  final int workoutId;

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _loading = true;
  List<Set> _sets = [];
  Workout? _workout;
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _deleteSet(int index, Set set) async {
    final removedSet = _sets[index];
    _sets.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(1.0, 0.0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
        child: FadeTransition(
          opacity: animation,
          child: _buildSlidableItem(removedSet, index),
        ),
      ),
      duration: Duration(milliseconds: 300),
    );
    await SetService.delete(set.id);
    if (_sets.isEmpty) {
      _loadSets();
    }
  }

  Widget _buildSlidableItem(Set set, int index) {
    final child = Slidable(
      key: Key(set.id.toString()),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => _deleteSet(index, set),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
            borderRadius: BorderRadius.circular(32),
          ),
        ],
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(index == 0 ? 12 : 2),
          bottom: Radius.circular(index == _sets.length - 1 ? 12 : 2),
        ),
        child: ListTile(
          visualDensity: VisualDensity(vertical: 2),
          title: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.grey),
              children: [
                TextSpan(
                  text: '${index + 1}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                TextSpan(text: ' подход: '),
                TextSpan(
                  text: '${set.weight}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                TextSpan(text: ' кг '),
                TextSpan(
                  text: '${set.repetitions}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                TextSpan(text: ' ${_getRepetitionWordCase(set.repetitions)}'),
              ],
            ),
          ),
          onTap: () async {
            final result = await showModalBottomSheet<Map<String, int>>(
              context: context,
              builder: (context) => SetForm(set: set),
            );
            if (result != null) {
              await SetService.update(
                Set(
                  id: set.id,
                  createdAt: set.createdAt,
                  updatedAt: set.updatedAt,
                  workoutId: set.workoutId,
                  weight: result['weight'] as int,
                  repetitions: result['repetitions'] as int,
                ),
              );
              await _loadSets();
            }
          },
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(bottom: 4), child: child);
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final results = await Future.wait([
      WorkoutService.getById(widget.workoutId),
      SetService.getAll(widget.workoutId),
    ]);

    setState(() {
      _workout = results[0] as Workout?;
      _sets = results[1] as List<Set>;
      _loading = false;
    });
  }

  Future<void> _loadSets() async {
    setState(() => _loading = true);

    final sets = await SetService.getAll(widget.workoutId);

    setState(() {
      _sets = sets;
      _loading = false;
    });
  }

  String _getRepetitionWordCase(int repetitionsCount) {
    if (repetitionsCount % 100 >= 11 && repetitionsCount % 100 <= 19) {
      return 'повторений';
    }
    switch (repetitionsCount % 10) {
      case 1:
        return 'повторение';
      case 2 || 3 || 4:
        return 'повторения';
      default:
        return 'повторений';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(
          _workout != null
              ? FormatDatetime.formatDate(_workout!.createdAt)
              : '',
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _sets.isEmpty
          ? Center(child: Text('Нет подходов'))
          : Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _sets.length,
                itemBuilder: (context, index, animation) {
                  return _buildSlidableItem(_sets[index], index);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet<Map<String, int>>(
            context: context,
            builder: (context) => SetForm(),
          );
          if (result != null) {
            await SetService.create(
              widget.workoutId,
              result['weight'] as int,
              result['repetitions'] as int,
            );
            _loadSets();
          }
        },
        tooltip: 'Новый подход',
        child: const Icon(Icons.add),
      ),
    );
  }
}
