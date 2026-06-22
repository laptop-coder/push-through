import 'package:flutter/material.dart';
import 'package:push_through/models/workout.dart';
import 'package:push_through/models/workout_type.dart';
import 'package:push_through/services/workout_service.dart';
import 'package:push_through/services/workout_type_service.dart';
import 'package:push_through/screens/workout_screen.dart';
import 'package:push_through/utils/format_datetime.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WorkoutTypeScreen extends StatefulWidget {
  const WorkoutTypeScreen({super.key, required this.workoutTypeId});
  final int workoutTypeId;

  @override
  State<WorkoutTypeScreen> createState() => _WorkoutTypeScreenState();
}

class _WorkoutTypeScreenState extends State<WorkoutTypeScreen> {
  bool _loading = true;
  List<Workout> _workouts = [];
  WorkoutType? _workoutType;
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _deleteWorkout(int index, Workout workout) async {
    final removedWorkout = _workouts[index];
    _workouts.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(1.0, 0.0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
        child: FadeTransition(
          opacity: animation,
          child: _buildSlidableItem(removedWorkout, index),
        ),
      ),
      duration: Duration(milliseconds: 300),
    );
    await WorkoutService.delete(workout.id);
    if (_workouts.isEmpty) {
      _loadWorkouts();
    }
  }

  Widget _buildSlidableItem(Workout workout, int index) {
    final child = Slidable(
      key: Key(workout.id.toString()),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => _deleteWorkout(index, workout),
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
          bottom: Radius.circular(index == _workouts.length - 1 ? 12 : 2),
        ),
        child: ListTile(
          visualDensity: VisualDensity(vertical: 2),
          title: Text(FormatDatetime.formatDate(workout.createdAt)),
          subtitle: Text(
            FormatDatetime.formatDateRelativeToToday(
              DateTime.parse(workout.createdAt.replaceAll(' ', 'T')),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutScreen(workoutId: workout.id),
              ),
            ).then((_) => _loadWorkouts());
          },
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(bottom: 4), child: child);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final results = await Future.wait([
      WorkoutTypeService.getById(widget.workoutTypeId),
      WorkoutService.getAll(widget.workoutTypeId),
    ]);

    setState(() {
      _workoutType = results[0] as WorkoutType?;
      _workouts = results[1] as List<Workout>;
      _loading = false;
    });
  }

  Future<void> _loadWorkouts() async {
    setState(() => _loading = true);

    final workouts = await WorkoutService.getAll(widget.workoutTypeId);

    setState(() {
      _workouts = workouts;
      _listKey = GlobalKey<AnimatedListState>();
      _loading = false;
    });
  }

  Future<void> _createWorkout() async {
    final id = await WorkoutService.create(widget.workoutTypeId);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkoutScreen(workoutId: id)),
    ).then((_) => _loadWorkouts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: Text(_workoutType != null ? _workoutType!.name : ''),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _workouts.isEmpty
          ? Center(child: Text('Нет тренировок'))
          : Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _workouts.length,
                itemBuilder: (context, index, animation) {
                  return _buildSlidableItem(_workouts[index], index);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkout,
        tooltip: 'Новая тренировка',
        child: const Icon(Icons.add),
      ),
    );
  }
}
