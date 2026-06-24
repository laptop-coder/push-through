import 'package:flutter/material.dart';
import 'package:push_through/services/workout_service.dart';
import 'package:push_through/models/set.dart';
import 'package:push_through/models/workout.dart';
import 'package:push_through/services/set_service.dart';
import 'package:push_through/widgets/set_form.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:push_through/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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
  late Locale _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locale = Localizations.localeOf(context);
    _loadData(_locale);
  }

  void _deleteSet(int index, Set set, Locale locale) async {
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
          child: _buildSlidableItem(removedSet, index, locale),
        ),
      ),
      duration: Duration(milliseconds: 300),
    );
    await SetService.delete(set.id);
    if (_sets.isEmpty) {
      _loadSets(locale);
    }
  }

  Widget _buildSlidableItem(Set set, int index, Locale locale) {
    final child = Slidable(
      key: Key(set.id.toString()),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (context) => _deleteSet(index, set, locale),
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
          bottom: Radius.circular(index == _sets.length - 1 ? 12 : 2),
        ),
        child: ListTile(
          visualDensity: VisualDensity(vertical: 2),
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              children: [
                TextSpan(
                  text: '${index + 1}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextSpan(text: ' ${AppLocalizations.of(context)!.set}: '),
                TextSpan(
                  text: '${set.weight}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextSpan(text: ' ${AppLocalizations.of(context)!.weightUnit} '),
                TextSpan(
                  text: '${set.repetitions}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text:
                      ' ${AppLocalizations.of(context)!.repetition(set.repetitions)}',
                ),
              ],
            ),
          ),
          onTap: () async {
            final result = await showModalBottomSheet<Map<String, num>>(
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
                  weight: result['weight'] as double,
                  repetitions: result['repetitions'] as int,
                ),
                locale,
              );
              await _loadSets(locale);
            }
          },
        ),
      ),
    );

    return Padding(padding: EdgeInsets.only(bottom: 4), child: child);
  }

  Future<void> _loadData(Locale locale) async {
    setState(() => _loading = true);

    final results = await Future.wait([
      WorkoutService.getById(widget.workoutId),
      SetService.getAll(widget.workoutId, locale),
    ]);

    setState(() {
      _workout = results[0] as Workout?;
      _sets = results[1] as List<Set>;
      _loading = false;
    });
  }

  Future<void> _loadSets(Locale locale) async {
    setState(() => _loading = true);

    final sets = await SetService.getAll(widget.workoutId, locale);

    setState(() {
      _sets = sets;
      _listKey = GlobalKey<AnimatedListState>();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(
          _workout != null
              ? DateFormat.yMd(
                  _locale.languageCode,
                ).format(DateTime.parse(_workout!.createdAt))
              : '',
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _sets.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noSets))
          : Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _sets.length,
                itemBuilder: (context, index, animation) {
                  return _buildSlidableItem(_sets[index], index, _locale);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet<Map<String, num>>(
            context: context,
            builder: (context) => SetForm(),
          );
          if (result != null) {
            await SetService.create(
              widget.workoutId,
              result['weight'] as double,
              result['repetitions'] as int,
              _locale,
            );
            _loadSets(_locale);
          }
        },
        tooltip: AppLocalizations.of(context)!.newSet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
