import 'package:flutter/material.dart';
import 'package:m3/logic/app_logic.dart';
import 'package:m3/ui/screen/home/home_screen.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await appLogic.bootstrap();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const HomeScreen(),
    );
  }
}

/// Add syntax sugar for quickly accessing the main "logic" controllers in the app
/// We deliberately do not create shortcuts for services, to discourage their use directly in the view/widget layer.
AppLogic get appLogic => AppLogic();


/// Global helpers for readability.
