class Flashcard {
  String subjectId;
  String chapter;
  String type;
  String question;
  String answer;

  Flashcard({
    required this.subjectId,
    required this.chapter,
    required this.question, 
    required this.type , 
    required this.answer
    });

  Map<String, dynamic> toJson(){
    return {
      'id' : subjectId,
      'chapter' :chapter,
      'type' : type,
      'question' : question,
      'answer' : answer
    };
  }

  factory Flashcard.fromMap(Map<String , dynamic> map){
    return Flashcard(
      subjectId: map['id'], 
      chapter: map['chapter'], 
      question: map['question'], 
      type: map['type'], 
      answer: map['answer']
      );
  }
}