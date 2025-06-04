import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme_provider.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            cardColor: Colors.grey[900],
            canvasColor: Colors.grey[900],
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
              titleLarge: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white70),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
