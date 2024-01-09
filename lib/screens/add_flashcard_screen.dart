import 'package:flutter/material.dart';

class AddFlashCardScreen extends StatefulWidget {

  final String subjectId;
  final String chapterName;

  const AddFlashCardScreen({Key? key , required this.subjectId , required this.chapterName}) : super(key:key);

  @override
  State<AddFlashCardScreen> createState() => _AddFlashCardScreenState();
}


enum FlashcardType{ normal, formula }

class _AddFlashCardScreenState extends State<AddFlashCardScreen> {

  FlashcardType? type = FlashcardType.normal;

  @override
  Widget build(BuildContext context) {
    final TextEditingController questionController = TextEditingController();
    final TextEditingController answerController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Flashcard"),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16),
        child : SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              const Text('Normal'),
              Radio<FlashcardType>(
                value: FlashcardType.normal,
                groupValue: type,
                onChanged: (FlashcardType? value) {
                  setState(() {
                    type = value;
                  });
                },
              ),
              const Text('Formula'),
              Radio<FlashcardType>(
                value: FlashcardType.formula,
                groupValue: type,
                onChanged: (FlashcardType? value) {
                  setState(() {
                    type = value;
                  });
                },
              ),
            ],
            ),
            const SizedBox(height: 40),
            TextField(
              controller: questionController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
                hintText: "Text displayed on the front.",
                hintStyle: TextStyle(fontSize: 12),
                filled: true,
                fillColor: Colors.grey
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: "Answer",
                border: OutlineInputBorder(),
                hintText: "Text displayed on the back.",
                hintStyle: TextStyle(fontSize: 12)
              ),
              maxLines: 5,

            ),
            const SizedBox(height:20),
            ElevatedButton(
              onPressed: (){
                  String question = questionController.text;
                  String answer = answerController.text;
                  print(question);
                  print(answer);
            }, 
            child: const Text("Submit")
            )
          ],
        ),
        )
        ),
      ),
    );
  }
}