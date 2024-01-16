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
          // scaffoldBackgroundColor: const Color.fromARGB(255, 36, 41, 62),
          scaffoldBackgroundColor: const Color.fromARGB(255, 6, 15, 20),
          appBarTheme: const AppBarTheme(
              // backgroundColor: Color.fromARGB(255, 47, 56, 85),
              shadowColor: Colors.black,
              backgroundColor: Color.fromARGB(255, 9, 21, 27),
              foregroundColor: Color.fromARGB(255, 244, 245, 252))),
      home: const SubjectScreen(),
      // home: ChapterScreen(),
    );
  }
}
