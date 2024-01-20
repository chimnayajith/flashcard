import 'package:flashcard/components/convert_to_latex.dart';
import 'package:flashcard/components/custom_snackbar.dart';
import 'package:flashcard/components/latex_helper.dart';
import 'package:flashcard/models/flashcard_model.dart';
import 'package:flashcard/repositories/flashcard_repository.dart';
import 'package:flashcard/screens/flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class AddFlashCardScreen extends StatefulWidget {
  final String subjectId;
  final String chapterName;
  const AddFlashCardScreen(
      {Key? key, required this.subjectId, required this.chapterName})
      : super(key: key);

  @override
  State<AddFlashCardScreen> createState() => _AddFlashCardScreenState();
}

enum FlashcardType { normal, complex }

class _AddFlashCardScreenState extends State<AddFlashCardScreen> {
  final _formKey = GlobalKey<FormState>();

  FlashcardType? type = FlashcardType.normal;
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  bool showHelp = false;
  final FlashcardRepository flashcardRepository = FlashcardRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 6, 15, 20),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 9, 21, 27),
              foregroundColor: Color.fromARGB(255, 244, 245, 252))),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Flashcard"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  showHelp = !showHelp;
                });
              },
              icon: showHelp
                  ? const Icon(Icons.help)
                  : const Icon(Icons.help_outline_outlined),
            ),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close)),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Normal',
                            style: TextStyle(
                                color: Color.fromARGB(255, 244, 245, 252),
                                fontSize: 18),
                          ),
                          Radio<FlashcardType>(
                            value: FlashcardType.normal,
                            groupValue: type,
                            onChanged: (FlashcardType? value) {
                              setState(() {
                                type = value;
                              });
                            },
                          ),
                          const Text('Complex',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 244, 245, 252),
                                  fontSize: 18)),
                          Radio<FlashcardType>(
                            value: FlashcardType.complex,
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
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a question";
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.white),
                                controller: questionController,
                                decoration: const InputDecoration(
                                    labelText: "Question",
                                    border: OutlineInputBorder(),
                                    hintText: "Text displayed on the front.",
                                    hintStyle: TextStyle(
                                        fontSize: 16, color: Colors.white30),
                                    filled: true,
                                    fillColor: Color.fromARGB(255, 25, 25, 25)),
                                maxLines: 5,
                              ),
                              const SizedBox(height: 40),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter an answer";
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.white),
                                controller: answerController,
                                decoration: const InputDecoration(
                                    labelText: "Answer",
                                    border: OutlineInputBorder(),
                                    hintText: "Text displayed on the back.",
                                    hintStyle: TextStyle(
                                        fontSize: 16, color: Colors.white30),
                                    filled: true,
                                    fillColor: Color.fromARGB(255, 25, 25, 25)),
                                maxLines: 5,
                              ),
                              const SizedBox(height: 20),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                              onPressed: () async {
                                String question = questionController.text;
                                String answer = answerController.text;

                                if (_formKey.currentState!.validate()) {
                                  String flashcardType =
                                      type.toString().split('.').last;
                                  String complex =
                                      convertToLatex(answerController.text);

                                  Flashcard flashcard = Flashcard(
                                      id: widget.subjectId,
                                      chapter: widget.chapterName,
                                      question: question,
                                      type: flashcardType,
                                      answer: answer,
                                      complexAnswer: complex);

                                  await flashcardRepository
                                      .addFlashcard(flashcard);

                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FlashcardScreen(
                                              subjectId: widget.subjectId,
                                              chapterName:
                                                  widget.chapterName)));
                                  showSuccessSnackBar(
                                      context, "Flashcard added successfully!");
                                }
                              },
                              child: const Text("Submit")))
                    ],
                  ),
                ),
                if (showHelp)
                  SingleChildScrollView(
                      child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.white),
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 54, 69, 79),
                            borderRadius: BorderRadius.circular(10)),
                        height: 800,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Inputting Equations & Formulas",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showHelp = !showHelp;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                              const SizedBox(height: 8),
                              table
                            ],
                          ),
                        )),
                  ))
              ],
            )),
      ),
    );
  }
}
