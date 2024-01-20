class Subjects {
  String id;
  String name;
  String? chapters;

  Subjects({
    required this.id,
    required this.name,
    this.chapters,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chapters': chapters,
    };
  }

  factory Subjects.fromMap(Map<String, dynamic> map) {
    return Subjects(
      id: map['id'],
      name: map['name'],
      chapters: map['chapters'],
    );
  }
}
