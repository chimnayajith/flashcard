import 'package:flashcard/models/flashcard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FlashcardRepository {
  Future<List<Flashcard>> getFlashcards(String id, String chapter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final flashcardsJson = prefs.getStringList('flashcard') ?? [];

    final filteredData = flashcardsJson
        .where((flashcard) =>
            Flashcard.fromMap(json.decode(flashcard)).subjectId == id &&
            Flashcard.fromMap(json.decode(flashcard)).chapter == chapter)
        .toList();

    final parsedFlashcards = filteredData
        .map((flashcard) => Flashcard.fromMap(json.decode(flashcard)))
        .toList();
    return parsedFlashcards;
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final flashcardsJson = prefs.getStringList('flashcard') ?? [];

    flashcardsJson.add(json.encode(flashcard.toJson()));
    prefs.setStringList('flashcard', flashcardsJson);
  }

  Future<void> deleteFlashcard(String subjectId, String chapterName,
      String question, String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final flashcardsJson = prefs.getStringList('flashcard') ?? [];

    flashcardsJson.removeWhere((flashcard) =>
        Flashcard.fromMap(json.decode(flashcard)).subjectId == subjectId &&
        Flashcard.fromMap(json.decode(flashcard)).chapter == chapterName &&
        Flashcard.fromMap(json.decode(flashcard)).question == question &&
        Flashcard.fromMap(json.decode(flashcard)).answer == answer);

    prefs.setStringList('flashcard', flashcardsJson);
  }

  Future<void> editFlashcard(
      Flashcard oldFlashcard, Flashcard editedFlashcard) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final flashcardsJson = prefs.getStringList('flashcard') ?? [];

    int index = flashcardsJson.indexWhere((flashcard) =>
        Flashcard.fromMap(json.decode(flashcard)).subjectId ==
            oldFlashcard.subjectId &&
        Flashcard.fromMap(json.decode(flashcard)).chapter ==
            oldFlashcard.chapter &&
        Flashcard.fromMap(json.decode(flashcard)).question ==
            oldFlashcard.question &&
        Flashcard.fromMap(json.decode(flashcard)).answer ==
            oldFlashcard.answer);
    flashcardsJson.removeAt(index);
    flashcardsJson.insert(index, json.encode(editedFlashcard.toJson()));
    prefs.setStringList("flashcard", flashcardsJson);
  }

  Future<void> chapterChanged(String id, String oldName, String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final flashcardsJson = prefs.getStringList('flashcard') ?? [];

    for (int i = 0; i < flashcardsJson.length; i++) {
      Flashcard decodedFlashcard = json.decode(flashcardsJson[i]);

      if (decodedFlashcard.subjectId == id &&
          decodedFlashcard.chapter == oldName) {
        decodedFlashcard.chapter = newName;
        flashcardsJson[i] = json.encode(decodedFlashcard);
      }
    }
    prefs.setStringList("flashcard", flashcardsJson);
  }
}
