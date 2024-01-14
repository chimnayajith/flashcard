// import 'package:flashcard/screens/chapters_screen.dart';
import 'package:flashcard/screens/subject_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(220, 36, 41, 62),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(220, 36, 41, 62),
              foregroundColor: Color.fromARGB(220, 244, 245, 252))),
      home: const SubjectScreen(),
      // home: ChapterScreen(),
    );
  }
}
