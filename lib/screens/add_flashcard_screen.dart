import 'package:flashcard/components/custom_snackbar.dart';
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
          scaffoldBackgroundColor: const Color.fromARGB(255, 36, 41, 62),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 36, 41, 62),
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
                              onPressed: () {
                                String question = questionController.text;
                                String answer = answerController.text;

                                if (_formKey.currentState!.validate()) {
                                  String flashcardType =
                                      type.toString().split('.').last;
                                  String complex =
                                      convertToLatex(answerController.text);

                                  Flashcard flashcard = Flashcard(
                                      subjectId: widget.subjectId,
                                      chapter: widget.chapterName,
                                      question: question,
                                      type: flashcardType,
                                      answer: answer,
                                      complexAnswer: complex);

                                  flashcardRepository.addFlashcard(flashcard);

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
                              DataTable(
                                dataRowHeight: 100,
                                columnSpacing: 16,
                                columns: const [
                                  DataColumn(label: Text('Input')),
                                  DataColumn(label: Text('         Output')),
                                ],
                                rows: [
                                  buildDataRow("sqrt(x)", r"\[\sqrt{x}\]"),
                                  buildDataRow("->", r"\[\rightarrow\]"),
                                  buildDataRow("infinity", r"\[\infty\]"),
                                  buildDataRow("+-", r"\[\pm\]"),
                                  buildDataRow("!=", r"\[\ne\]"),
                                  buildDataRow("sin cos tan ...",
                                      r"\[\sin \cos \tan..\]"),
                                  buildDataRow("x^y", r"\[ x^y \]"),
                                  buildDataRow("x_n", r"\[ x_n \]"),
                                  buildDataRow(
                                      "(num) / (den)", r"\[\frac{num}{den}\]"),
                                  buildDataRow("alpha beta gamma ...",
                                      r"\[ \alpha \beta \gamma \epsilon \rho \sigma \delta \]"),
                                  buildDataRow("integral(func, a, b)",
                                      r"\[\int_{a}^{b} func\]"),
                                  buildDataRow(
                                      "sum(k, a, b)", r"\[\sum_{k= a}^{b}\]"),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ))
              ],
            )),
      ),
    );
  }

  DataRow buildDataRow(String input, String output) {
    return DataRow(cells: [
      DataCell(Container(
        width: 200,
        child: Text(
          input,
          style: TextStyle(fontSize: 17),
          overflow: TextOverflow.ellipsis,
        ),
      )),
      DataCell(Container(
        width: 100,
        child: TeXView(
          child: TeXViewDocument(output,
              style: TeXViewStyle(textAlign: TeXViewTextAlign.left)),
        ),
      )),
    ]);
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
