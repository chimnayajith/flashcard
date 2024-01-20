import 'package:flashcard/components/custom_snackbar.dart';
import 'package:flashcard/models/subject_model.dart';
import 'package:flashcard/screens/flashcard_screen.dart';
import 'package:flashcard/screens/subject_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashcard/repositories/subject_repository.dart';

class ChaptersScreen extends StatefulWidget {
  final String subjectId;

  const ChaptersScreen({Key? key, required this.subjectId}) : super(key: key);

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  final _formKey = GlobalKey<FormState>();
  late Future<Subjects?> _subjectFuture;
  final SubjectRepository subjectRepository = SubjectRepository();

  final navigatorKey = GlobalKey<NavigatorState>();

  final TextEditingController chapterController = TextEditingController();
  final TextEditingController editChapterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subjectFuture = subjectRepository.getSubjectById(widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SubjectScreen()));
        return true;
      },
      child: FutureBuilder(
          future: _subjectFuture,
          builder: (context, AsyncSnapshot<Subjects?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            } else {
              Subjects subject = snapshot.data!;
              List<String> chapters =
                  subject.chapters != null ? subject.chapters!.split(",") : [];
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    subject.name,
                    textAlign: TextAlign.left,
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 92, 131, 116),
                  onPressed: () {
                    openDialog(context, subject.id);
                  },
                  child: const Icon(Icons.add,
                      color: Color.fromARGB(255, 225, 223, 216)),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                body: ListView(
                  padding: const EdgeInsets.all(10),
                  children: chapters.isNotEmpty
                      ? chapters.map((each) {
                          return _buildCard(subject.id, each);
                        }).toList()
                      : [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('./lib/assets/empty.png'),
                              const Text(
                                'No chapters yet!',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 244, 245, 252)),
                              ),
                              const Text(
                                'Add using the + icon.',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              )
                            ],
                          )
                        ],
                ),
              );
            }
          }),
    );
  }

  void openDialog(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (context) => Form(
              key: _formKey,
              child: AlertDialog(
                title: const Text("Add Chapter"),
                content: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a chapter name!";
                    }
                  },
                  controller: chapterController,
                  autofocus: true,
                  decoration:
                      const InputDecoration(hintText: "Enter Chapter Name"),
                  textCapitalization: TextCapitalization.words,
                ),
                contentPadding: const EdgeInsets.all(20),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          submitChapter(context, id, chapterController.text);
                        }
                      },
                      child: const Text('Submit'))
                ],
              ),
            ));
  }

  void submitChapter(
      BuildContext context, String subjectId, String chapterName) async {
    await subjectRepository.addChapterToSubject(subjectId, chapterName);
    Navigator.of(context).pop();

    setState(() {
      _subjectFuture = subjectRepository.getSubjectById(widget.subjectId);
    });
    showSuccessSnackBar(context, "Chapter added successfully!");
  }

  Widget _buildCard(String id, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FlashcardScreen(subjectId: id, chapterName: text)));
      },
      child: Card(
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          tileColor: const Color.fromARGB(255, 24, 61, 61),
          title: Text(
            text,
            style: const TextStyle(
                color: Color.fromARGB(255, 244, 245, 252),
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.2),
          ),
          trailing: PopupMenuButton(
              icon: const Icon(Icons.more_vert,
                  color: Color.fromARGB(255, 244, 245, 252)),
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit')
                          ],
                        ),
                        onTap: () {
                          openEditDialog(context, id, text);
                        }),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.red.shade600),
                          )
                        ],
                      ),
                      onTap: () {
                        confirmDelete(context, id, text);
                      },
                    ),
                  ]),
        ),
      ),
    );
  }

  void openEditDialog(BuildContext context, String id, String oldName) {
    editChapterController.text = oldName;
    showDialog(
        context: context,
        builder: (context) => Form(
              key: _formKey,
              child: AlertDialog(
                title: const Text("Edit Chapter Name"),
                content: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a chapter name!";
                      }
                    },
                    controller: editChapterController,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: "Enter Chapter Name")),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await subjectRepository.editChapter(
                              id, editChapterController.text, oldName);
                          Navigator.of(context).pop();
                          setState(() {
                            _subjectFuture =
                                subjectRepository.getSubjectById(id);
                          });
                          showSuccessSnackBar(
                              context, "Chapter edited successfully!");
                        }
                      },
                      child: const Text('Submit'))
                ],
              ),
            ));
  }

  // dialog to confirm chapter deletion
  void confirmDelete(BuildContext context, String id, String text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Confirmation"),
              content: RichText(
                  text: TextSpan(
                      text: "Are you sure you want to delete the chapter : ",
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                        text: text,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: " ?")
                  ])),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      await subjectRepository.removeChapterFromSubject(
                          id, text);
                      Navigator.of(context).pop();
                      setState(() {
                        _subjectFuture =
                            subjectRepository.getSubjectById(widget.subjectId);
                      });
                      showSuccessSnackBar(context, "Chapter deleted!");
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }
}
