import 'package:flutter/material.dart';
import 'package:push_through/models/workout_type.dart';
import 'package:push_through/services/workout_type_service.dart';
import 'package:push_through/screens/workout_type_screen.dart';
import 'package:push_through/widgets/workout_type_form.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  List<WorkoutType> _workoutTypes = [];
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _deleteWorkoutType(int index, WorkoutType workoutType) async {
    final removedWorkoutType = _workoutTypes[index];
    _workoutTypes.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(1.0, 0.0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
        child: FadeTransition(
          opacity: animation,
          child: _buildSlidableItem(removedWorkoutType, index),
        ),
      ),
      duration: Duration(milliseconds: 300),
    );
    await WorkoutTypeService.delete(workoutType.id);
    if (_workoutTypes.isEmpty) {
      _loadWorkoutTypes();
    }
  }

  Widget _buildSlidableItem(WorkoutType workoutType, int index) {
    final child = Slidable(
      key: Key(workoutType.id.toString()),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => _deleteWorkoutType(index, workoutType),
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
          bottom: Radius.circular(index == _workoutTypes.length - 1 ? 12 : 2),
        ),
        child: ListTile(
          visualDensity: VisualDensity(vertical: 2),
          title: Text(workoutType.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    WorkoutTypeScreen(workoutTypeId: workoutType.id),
              ),
            ).then((_) => _loadWorkoutTypes());
          },
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(bottom: 4), child: child);
  }

  @override
  void initState() {
    super.initState();
    _loadWorkoutTypes();
  }

  Future<void> _loadWorkoutTypes() async {
    final workoutTypes = await WorkoutTypeService.getAll();
    setState(() {
      _workoutTypes = workoutTypes;
      _listKey = GlobalKey<AnimatedListState>();
      _loading = false;
    });
  }

  Future<void> _createWorkoutType() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      builder: (context) => WorkoutTypeForm(),
    );
    if (result != null &&
        result['name'] != null &&
        result['name']!.isNotEmpty) {
      final id = await WorkoutTypeService.create(result['name']!);
      await _loadWorkoutTypes();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutTypeScreen(workoutTypeId: id),
        ),
      ).then((_) => _loadWorkoutTypes());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: const Text('Дожми! Тренировки'),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _workoutTypes.isEmpty
          ? Center(child: Text('Нет упражнений'))
          : Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _workoutTypes.length,
                itemBuilder: (context, index, animation) {
                  return _buildSlidableItem(_workoutTypes[index], index);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkoutType,
        tooltip: 'Новое упражнение',
        child: const Icon(Icons.add),
      ),
    );
  }
}
