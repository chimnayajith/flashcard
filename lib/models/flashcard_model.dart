class Flashcard {
  String id;
  String chapter;
  String type;
  String question;
  String answer;
  String complexAnswer;

  Flashcard(
      {required this.id,
      required this.chapter,
      required this.question,
      required this.type,
      required this.answer,
      required this.complexAnswer});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter': chapter,
      'type': type,
      'question': question,
      'answer': answer,
      'complex': complexAnswer
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
        id: map['id'],
        chapter: map['chapter'],
        question: map['question'],
        type: map['type'],
        answer: map['answer'],
        complexAnswer: map['complex']);
  }
}
