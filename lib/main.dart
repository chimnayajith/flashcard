import 'package:flashcard/repositories/database_helper.dart';
import 'package:flashcard/screens/onboarding_screen.dart';
import 'package:flashcard/screens/subject_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Database? db = await DatabaseHelper.instance.database;
  List<Map<String, dynamic>> result =
      await db!.rawQuery("SELECT * FROM isFirstTime");
  bool isFirstTime = result.isEmpty;
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
      home: isFirstTime ? const OnboardingScreen() : const SubjectScreen(),
    );
  }
}
