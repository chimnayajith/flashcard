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
      theme: new ThemeData(scaffoldBackgroundColor: Colors.black45, appBarTheme: AppBarTheme(backgroundColor: Colors.black45 , foregroundColor: Colors.white)),
      home: SubjectScreen(),
      // home: ChapterScreen(),
    );
  }
}
