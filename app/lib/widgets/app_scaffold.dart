import 'package:flutter/material.dart';
import 'package:push_through/screens/home_screen.dart';
import 'package:push_through/screens/data_screen.dart';
import 'package:push_through/l10n/app_localizations.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentScreenIndex = 0;

  final List<Widget> _screens = [HomeScreen(), DataScreen()];

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [
      NavigationDestination(
        selectedIcon: Icon(Icons.home),
        icon: Icon(Icons.home_outlined),
        label: AppLocalizations.of(context)!.workouts,
      ),
      NavigationDestination(
        selectedIcon: Icon(Icons.upload),
        icon: Icon(Icons.upload_outlined),
        label: AppLocalizations.of(context)!.dataImportExport,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
        selectedIndex: _currentScreenIndex,
        destinations: buttons,
      ),
      body: _screens[_currentScreenIndex],
    );
  }
}
