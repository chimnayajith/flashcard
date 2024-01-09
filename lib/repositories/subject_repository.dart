import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flashcard/models/subject_model.dart';

class SubjectRepository {
  Future<List<Subjects>> getSubjects () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getStringList('subjects') ?? [];
    return subjectsJson.map((subject) => Subjects.fromMap(json.decode(subject))).toList();
  }


  Future<void> addSubject(Subjects subject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getStringList('subjects') ?? [];
    subjectsJson.add(json.encode(subject.toJson()));
    prefs.setStringList('subjects' , subjectsJson);
  }

  Future<Subjects?> getSubjectById(String subjectId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getStringList('subjects') ?? [];
    final subjectData = subjectsJson.firstWhere((element){
      final decodedSubject = json.decode(element);
      return decodedSubject['id'] == subjectId;
    },
    );
    final parsedSubject = Subjects.fromMap(json.decode(subjectData));
    return parsedSubject;
  }


  Future<void> addChapterToSubject(String subjectId , String chapterName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getStringList('subjects') ?? [];

    int index = subjectsJson.indexWhere((element) {
      final decodedSubject = json.decode(element);
      return decodedSubject['id'] == subjectId;
    });

    if(index!=-1){
      Map<String , dynamic> decodedSubject = json.decode(subjectsJson[index]);
      List<String> chapters = decodedSubject['chapters'].cast<String>();
      chapters.add(chapterName);
      decodedSubject['chapters'] = chapters;

      subjectsJson[index] = json.encode(decodedSubject);
      prefs.setStringList('subjects', subjectsJson);

    }
  }


  Future<void> removeChapterFromSubject(String subjectId , String chapterName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final subjectsJson = prefs.getStringList('subjects') ?? [];

    int index = subjectsJson.indexWhere((element) {
      final decodedSubject = json.decode(element);
      return decodedSubject['id'] == subjectId;
    });

    if(index!=-1){
      Map<String , dynamic> decodedSubject = json.decode(subjectsJson[index]);
      List<String> chapters = decodedSubject['chapters'].cast<String>();
      chapters.remove(chapterName);
      decodedSubject['chapters'] = chapters;

      subjectsJson[index] = json.encode(decodedSubject);
      prefs.setStringList('subjects', subjectsJson);

    }
  }

  // for development only
   Future<void> clearSubjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('subjects');
  }
}