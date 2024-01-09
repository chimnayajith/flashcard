class Subjects {
  String id;
  String name;
  List<String> chapters;

  Subjects ({
    required this.id,
    required this.name, 
    required this.chapters,
  });

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'chapters': chapters,
    };
  }

  factory Subjects.fromMap(Map<String, dynamic> map) {
     final decodedChapters = map['chapters'] as List<dynamic>?;

    return Subjects(
      id: map['id'],
      name: map['name'] ,
      chapters : List<String>.from(decodedChapters ?? []),
    );
}

}