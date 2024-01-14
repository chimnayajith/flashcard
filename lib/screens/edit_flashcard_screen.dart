import 'package:flashcard/models/flashcard_model.dart';
import 'package:flashcard/repositories/flashcard_repository.dart';
import 'package:flashcard/screens/flashcard_screen.dart';
import 'package:flutter/material.dart';

class EditFlashcardScreen extends StatefulWidget {
  final Flashcard flashcard;
  const EditFlashcardScreen({Key? key, required this.flashcard})
      : super(key: key);

  @override
  State<EditFlashcardScreen> createState() => _EditFlashcardScreenState();
}

enum FlashcardType { normal, complex }

class _EditFlashcardScreenState extends State<EditFlashcardScreen> {
  FlashcardType? type;

  final FlashcardRepository flashcardRepository = FlashcardRepository();

  @override
  void initState() {
    super.initState();
    type = widget.flashcard.type == "normal"
        ? FlashcardType.normal
        : FlashcardType.complex;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController questionController =
        TextEditingController(text: widget.flashcard.question);
    final TextEditingController answerController =
        TextEditingController(text: widget.flashcard.answer);
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black, foregroundColor: Colors.white)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Flashcard"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Normal',
                        style: TextStyle(
                            color: Color.fromARGB(220, 244, 245, 252)),
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
                              color: Color.fromARGB(220, 244, 245, 252))),
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
                  TextField(
                    controller: questionController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: "Question",
                        border: OutlineInputBorder(),
                        hintText: "Text displayed on the front.",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.white30),
                        filled: true,
                        fillColor: Color.fromARGB(220, 25, 25, 25)),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: answerController,
                    decoration: const InputDecoration(
                        labelText: "Answer",
                        border: OutlineInputBorder(),
                        hintText: "Text displayed on the back.",
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.white30),
                        filled: true,
                        fillColor: Color.fromARGB(220, 25, 25, 25)),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 300),
                    child: ElevatedButton(
                        onPressed: () {
                          String question = questionController.text;
                          String flashcardType =
                              type.toString().split('.').last;
                          String answer = answerController.text;
                          String complex =
                              convertToLatex(answerController.text);

                          Flashcard editedFlashcard = Flashcard(
                              subjectId: widget.flashcard.subjectId,
                              chapter: widget.flashcard.chapter,
                              question: question,
                              type: flashcardType,
                              answer: answer,
                              complexAnswer: complex);

                          flashcardRepository.editFlashcard(
                              widget.flashcard, editedFlashcard);

                          // Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FlashcardScreen(
                                      subjectId: widget.flashcard.subjectId,
                                      chapterName: widget.flashcard.chapter)),
                              (route) => false);
                        },
                        child: const Text("Submit")),
                  )
                ],
              ),
            )),
      ),
    );
  }

  String convertToLatex(String input) {
    // square root with single characters
    input = input.replaceAllMapped(RegExp(r'sqrt\s*\((.*?)\)'), (match) {
      return "\\sqrt{${match[1]}}";
    });

    // arrow for chemistry
    input = input.replaceAll('->', '\\rightarrow');

    // using infinity
    input = input.replaceAll('infinity', '\\infty');

    // plus or minus operator
    input = input.replaceAll('+-', '\\pm');

    // not equal to
    input = input.replaceAll('!=', '\\ne');

    // trigonometric functions
    input = input.replaceAll("sin", "\\sin");
    input = input.replaceAll("cos", "\\cos");
    input = input.replaceAll("tan", "\\tan");
    input = input.replaceAll("sec", "\\sec");
    input = input.replaceAll("cosec", "\\cosec");
    input = input.replaceAll("cot", "\\cot");

    // superscripts
    input = input.replaceAllMapped(
        RegExp(r'([a-zA-Z0-9]+)\^(?![{^_])'), (match) => '${match[1]}^');

    // subscripts
    input = input.replaceAllMapped(
        RegExp(r'([a-zA-Z0-9]+)\_(?![{^_])'), (match) => '${match[1]}_');

    //handling fractions of different patterns
    input = input.replaceAllMapped(
        RegExp(
            r'\((.*?)\)\s*\/\s*\((.*?)\)|([a-zA-Z0-9]+)\s*\/\s*([a-zA-Z0-9]+)|(\d+)\s*\/\s*(\d+)|\((.*?)\)\s*\/\s*([a-zA-Z0-9]+)|([a-zA-Z0-9]+)\s*\/\s*\((.*?)\)'),
        (match) {
      String? nr = match[1] ?? match[3] ?? match[5] ?? match[7] ?? match[9];
      String? dr = match[2] ?? match[4] ?? match[6] ?? match[8] ?? match[10];
      return '\\frac{$nr} {$dr}';
    });
    // greek albabets
    input = input.replaceAll("alpha", "\\alpha");
    input = input.replaceAll("beta", "\\beta");
    input = input.replaceAll("gamma", "\\gamma");
    input = input.replaceAll("rho", "\\rho");
    input = input.replaceAll("sigma", "\\sigma");
    input = input.replaceAll("delta", "\\delta");
    input = input.replaceAll("epsilon", "\\epsilon");

    // integration : format => integral(required function , lower limit , upper limit)
    input = input.replaceAllMapped(
        RegExp(r'integral\(([^,]+)?,\s*([^,]+)?,\s*(.+)?\)'), (match) {
      String integrand = match[1] ?? '';
      String lowerLimit = match[2] ?? '';
      String upperLimit = match[3] ?? '';

      if (lowerLimit.isNotEmpty && upperLimit.isNotEmpty) {
        return '\\int_{$lowerLimit}^{$upperLimit} $integrand';
      } else {
        return '\\int $integrand';
      }
    });

    // Summation : format => sum(variable , lower limit , upper limit)
    input = input.replaceAllMapped(
        RegExp(r'sum\(([^,]+)?,\s*([^,]+)?,\s*(.+)?\)'), (match) {
      String variable = match[1] ?? '';
      String lowerLimit = match[2] ?? '';
      String upperLimit = match[3] ?? '';

      if (variable.isNotEmpty &&
          lowerLimit.isNotEmpty &&
          upperLimit.isNotEmpty) {
        return '\\sum_{$variable = $lowerLimit}^{$upperLimit}';
      } else {
        return "\\sum";
      }
    });

    // wrapping in \[...\]
    input = r"\[" + input + r"\]";
    return input;
  }
}
