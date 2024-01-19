import 'package:flashcard/screens/onboarding_screen.dart';
import 'package:flashcard/screens/subject_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({Key? key, required this.isFirstTime}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 6, 15, 20),
          appBarTheme: const AppBarTheme(
              shadowColor: Colors.black,
              backgroundColor: Color.fromARGB(255, 9, 21, 27),
              foregroundColor: Color.fromARGB(255, 244, 245, 252))),
      // home: isFirstTime ? const OnboardingScreen() : const SubjectScreen(),
      home: const OnboardingScreen(),
    );
  }
}
