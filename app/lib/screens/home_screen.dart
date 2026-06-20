import 'package:flutter/material.dart';
import 'package:push_through/models/workout.dart';
import 'package:push_through/services/workout_service.dart';
import 'package:push_through/screens/workout_screen.dart';
import 'package:push_through/utils/format_datetime.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final workouts = await WorkoutService.getAll();
    setState(() {
      _workouts = workouts;
      _loading = false;
    });
  }

  Future<void> _createWorkout() async {
    final id = await WorkoutService.create();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkoutScreen(workoutId: id)),
    ).then((_) => _loadWorkouts());
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _workouts.isEmpty
          ? Center(child: Text('Нет тренировок'))
          : ListView.builder(
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                final workout = _workouts[index];
                return Card(
                  child: ListTile(
                    title: Text(FormatDatetime.formatDate(workout.createdAt)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkoutScreen(workoutId: workout.id),
                        ),
                      ).then((_) => _loadWorkouts());
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkout,
        tooltip: 'Новая тренировка',
        child: const Icon(Icons.add),
      ),
    );
  }
}
