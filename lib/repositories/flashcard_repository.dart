import 'package:flashcard/models/flashcard_model.dart';
import 'package:flashcard/repositories/database_helper.dart';

import 'package:sqflite/sqflite.dart';

class FlashcardRepository {
  Future<List<Flashcard>> getFlashcards(String id, String chapter) async {
    final Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!.rawQuery(
        "SELECT * FROM flashcards WHERE id = '$id' AND chapter = '$chapter'");
    List<Flashcard> flashcards =
        result.map((each) => Flashcard.fromMap(each)).toList();

    return flashcards;
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    final Database? db = await DatabaseHelper.instance.database;

    await db!.insert('flashcards', flashcard.toJson());
  }

  Future<void> deleteFlashcard(String subjectId, String chapterName,
      String question, String answer) async {
    final Database? db = await DatabaseHelper.instance.database;

    await db!.delete('flashcards',
        where: 'id = ? AND chapter = ? AND question = ? AND answer = ?',
        whereArgs: [subjectId, chapterName, question, answer]);
  }

  Future<void> editFlashcard(
      Flashcard oldFlashcard, Flashcard editedFlashcard) async {
    final Database? db = await DatabaseHelper.instance.database;

    await db!.update('flashcards', editedFlashcard.toJson(),
        where: 'id = ? AND chapter = ? AND question = ? AND answer = ?',
        whereArgs: [
          oldFlashcard.id,
          oldFlashcard.chapter,
          oldFlashcard.question,
          oldFlashcard.answer
        ]);
  }

  Future<void> chapterChanged(String id, String oldName, String newName) async {
    final Database? db = await DatabaseHelper.instance.database;

    await db!.update('flashcards', {'chapter': newName},
        where: 'id = ? AND chapter = ?', whereArgs: [id, oldName]);
  }
}
