import 'package:flashcard/models/flashcard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FlashcardRepository {
  Future<List<Flashcard>> getFlashcards( String id , String chapter ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final flashcardsJson = prefs.getStringList('flashcard') ?? [];

    final filteredData = flashcardsJson.where((flashcard) => 
      Flashcard.fromMap(json.decode(flashcard)).subjectId == id &&
      Flashcard.fromMap(json.decode(flashcard)).chapter == chapter
    ).toList();

    final parsedFlashcards = filteredData.map((flashcard) => Flashcard.fromMap(json.decode(flashcard))).toList();
    return parsedFlashcards;
  }
}