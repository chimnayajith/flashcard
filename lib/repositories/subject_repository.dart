import 'package:flashcard/repositories/database_helper.dart';
import 'package:flashcard/repositories/flashcard_repository.dart';
import 'package:flashcard/models/subject_model.dart';
import 'package:sqflite/sqflite.dart';

class SubjectRepository {
  Future<List<Subjects>> getSubjects() async {
    final Database? db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> subjectsJson = await db!.query('subjects');
    return subjectsJson.map((subject) => Subjects.fromMap(subject)).toList();
  }

  Future<void> addSubject(Subjects subject) async {
    final Database? db = await DatabaseHelper.instance.database;
    await db!.insert('subjects', subject.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeSubject(String id) async {
    final Database? db = await DatabaseHelper.instance.database;
    db?.delete('subjects', where: 'id=?', whereArgs: [id]);
  }

  Future<void> editSubject(String id, String name) async {
    final Database? db = await DatabaseHelper.instance.database;
    await db?.update('subjects', {'name': name},
        where: 'id=?', whereArgs: [id]);
  }

  Future<Subjects?> getSubjectById(String subjectId) async {
    final Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!.query(
      'subjects',
      where: 'id=?',
      whereArgs: [subjectId],
    );
    if (result.isNotEmpty) {
      return Subjects.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<void> addChapterToSubject(String subjectId, String chapterName) async {
    final Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!
        .rawQuery("SELECT chapters FROM subjects WHERE id='$subjectId'");
    List<String> chapters = result.first['chapters'] != null
        ? result.first['chapters'].split(",")
        : [];
    chapters.add(chapterName);
    await db.update('subjects', {'chapters': chapters.join(',')},
        where: 'id=?', whereArgs: [subjectId]);
  }

  Future<void> removeChapterFromSubject(
      String subjectId, String chapterName) async {
    final Database? db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> result = await db!.query(
      'subjects',
      where: 'id=?',
      whereArgs: [subjectId],
    );

    if (result.isNotEmpty) {
      Map<String, dynamic> subjectData = result.first;
      List<String> chapters = (subjectData['chapters'] as String).split(',');

      chapters.remove(chapterName);
      await db.update('subjects',
          {'chapters': chapters.isNotEmpty ? chapters.join(',') : null},
          where: 'id=?', whereArgs: [subjectId]);
    }
  }

  Future<void> editChapter(String id, String newName, String oldName) async {
    final Database? db = await DatabaseHelper.instance.database;
    final FlashcardRepository flashcardRepository = FlashcardRepository();
    List<Map<String, dynamic>> result = await db!.query(
      'subjects',
      where: 'id=?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      Map<String, dynamic> subjectData = result.first;
      List<String> chapters = (subjectData['chapters'] as String).split(',');
      int index = chapters.indexOf(oldName);
      chapters.remove(oldName);
      chapters.insert(index, newName);
      await db.update('subjects', {'chapters': chapters.join(',')},
          where: 'id=?', whereArgs: [id]);
      flashcardRepository.chapterChanged(id, oldName, newName);
    }
  }
}
