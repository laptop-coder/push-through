import 'package:flutter/material.dart';
import 'package:push_through/models/workout.dart';
import 'package:push_through/models/exercise.dart';
import 'package:push_through/services/workout_service.dart';
import 'package:push_through/services/exercise_service.dart';
import 'package:push_through/screens/workout_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:push_through/l10n/app_localizations.dart';
import 'package:relative_time/relative_time.dart';
import 'package:intl/intl.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key, required this.exerciseId});
  final int exerciseId;

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  bool _loading = true;
  List<Workout> _workouts = [];
  Exercise? _exercise;
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late Locale _locale;

  void _deleteWorkout(int index, Workout workout, Locale locale) async {
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
          child: _buildSlidableItem(removedWorkout, index, locale),
        ),
      ),
      duration: Duration(milliseconds: 300),
    );
    await WorkoutService.delete(workout.id);
    if (_workouts.isEmpty) {
      _loadWorkouts();
    }
  }

  Widget _buildSlidableItem(Workout workout, int index, Locale locale) {
    final child = Slidable(
      key: Key(workout.id.toString()),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => _deleteWorkout(index, workout, locale),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            icon: Icons.delete,
            label: AppLocalizations.of(context)!.delete,
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
          title: Text(
            DateFormat.yMd(
              locale.languageCode,
            ).format(DateTime.parse(workout.createdAt)),
          ),
          subtitle: Text(
            DateTime.parse(
              workout.createdAt.replaceAll(' ', 'T'),
            ).relativeTime(context),
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
  didChangeDependencies() {
    super.didChangeDependencies();
    _locale = Localizations.localeOf(context);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final results = await Future.wait([
      ExerciseService.getById(widget.exerciseId),
      WorkoutService.getAll(widget.exerciseId),
    ]);

    setState(() {
      _exercise = results[0] as Exercise?;
      _workouts = results[1] as List<Workout>;
      _loading = false;
    });
  }

  Future<void> _loadWorkouts() async {
    setState(() => _loading = true);

    final workouts = await WorkoutService.getAll(widget.exerciseId);

    setState(() {
      _workouts = workouts;
      _listKey = GlobalKey<AnimatedListState>();
      _loading = false;
    });
  }

  Future<void> _createWorkout() async {
    final id = await WorkoutService.create(widget.exerciseId);
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
        title: Text(_exercise != null ? _exercise!.name : ''),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _workouts.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noWorkouts))
          : Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _workouts.length,
                itemBuilder: (context, index, animation) {
                  return _buildSlidableItem(_workouts[index], index, _locale);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkout,
        tooltip: AppLocalizations.of(context)!.newWorkout,
        child: const Icon(Icons.add),
      ),
    );
  }
}
