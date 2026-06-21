import 'package:flutter/material.dart';
import 'package:push_through/screens/home_screen.dart';
import 'package:push_through/screens/data_screen.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentScreenIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(title: 'Дожми! Жим лёжа'),
    DataScreen(title: 'Импорт/экспорт данных'),
  ];
  final List<Widget> _buttons = [
    NavigationDestination(
      selectedIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      label: 'Тренировки',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.upload),
      icon: Icon(Icons.upload_outlined),
      label: 'Импорт/экспорт данных',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
        selectedIndex: _currentScreenIndex,
        destinations: _buttons,
      ),
      body: _screens[_currentScreenIndex],
    );
  }
}
