import 'package:flutter/material.dart';
import 'package:push_through/widgets/app_scaffold.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme:
                lightDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.blueGrey,
                  brightness: Brightness.light,
                ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme:
                darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.blueGrey,
                  brightness: Brightness.dark,
                ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
              },
            ),
          ),
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: AppScaffold(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale('ru'),
          supportedLocales: [Locale('ru')],
        );
      },
    );
  }
}
