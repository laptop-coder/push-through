import 'package:flutter/material.dart';
import 'package:push_through/models/exercise.dart';
import 'package:push_through/services/exercise_service.dart';
import 'package:push_through/screens/exercise_screen.dart';
import 'package:push_through/widgets/exercise_form.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:push_through/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  List<Exercise> _exercises = [];
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _deleteExercise(int index, Exercise exercise) async {
    final removedExercise = _exercises[index];
    _exercises.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(1.0, 0.0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
        child: FadeTransition(
          opacity: animation,
          child: _buildSlidableItem(removedExercise, index),
        ),
      ),
      duration: Duration(milliseconds: 300),
    );
    await ExerciseService.delete(exercise.id);
    if (_exercises.isEmpty) {
      _loadExercises();
    }
  }

  Widget _buildSlidableItem(Exercise exercise, int index) {
    final child = Slidable(
      key: Key(exercise.id.toString()),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => _deleteExercise(index, exercise),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
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
          bottom: Radius.circular(index == _exercises.length - 1 ? 12 : 2),
        ),
        child: ListTile(
          visualDensity: VisualDensity(vertical: 2),
          title: Text(exercise.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ExerciseScreen(exerciseId: exercise.id),
              ),
            ).then((_) => _loadExercises());
          },
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(bottom: 4), child: child);
  }

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final exercises = await ExerciseService.getAll();
    setState(() {
      _exercises = exercises;
      _listKey = GlobalKey<AnimatedListState>();
      _loading = false;
    });
  }

  Future<void> _createExercise() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      builder: (context) => ExerciseForm(),
    );
    if (result != null &&
        result['name'] != null &&
        result['name']!.isNotEmpty) {
      final id = await ExerciseService.create(result['name']!);
      await _loadExercises();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExerciseScreen(exerciseId: id),
        ),
      ).then((_) => _loadExercises());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: Text(AppLocalizations.of(context)!.appTitleFull),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _exercises.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noExercises))
          : Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _exercises.length,
                itemBuilder: (context, index, animation) {
                  return _buildSlidableItem(_exercises[index], index);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createExercise,
        tooltip: AppLocalizations.of(context)!.newExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}
