import 'package:flashcard/models/subject_model.dart';
import 'package:flashcard/repositories/subject_repository.dart';
import 'package:flashcard/screens/chapters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  late Future<List<Subjects>> _subjectFuture;
  final navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController editSubjectController = TextEditingController();

  final SubjectRepository subjectRepository = SubjectRepository();

  @override
  void initState() {
    super.initState();
    _subjectFuture = subjectRepository.getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
        // return true;
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Subjects'),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(220, 26, 19, 38),
                      ),
                      child: Text(
                        'RecallX',
                        style: TextStyle(
                          color: Color.fromARGB(220, 244, 245, 252),
                          fontSize: 24,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.message),
                      title: const Text('Messages'),
                      onTap: () {
                        setState(() {
                          // selectedPage = 'Messages';
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: const Text('Profile'),
                      onTap: () {
                        setState(() {
                          // selectedPage = 'Profile';
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        setState(() {
                          // selectedPage = 'Settings';
                        });
                      },
                    ),
                  ],
                ),
              ),
              body: FutureBuilder(
                  future: _subjectFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Scaffold(
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('./lib/assets/empty.png'),
                            const Text(
                              'No subjects yet!',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(220, 244, 245, 252)),
                            ),
                            const Text(
                              'Add using the + icon.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          ],
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () {
                            openDialog(context);
                          },
                          backgroundColor:
                              const Color.fromARGB(255, 47, 56, 85),
                          child: const Icon(Icons.add,
                              color: Color.fromARGB(220, 225, 223, 216)),
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.endFloat,
                      );
                    } else {
                      return Scaffold(
                        body: GridView.count(
                          primary: false,
                          padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: snapshot.data!.map((subject) {
                            return _buildGridItem(subject.id, subject.name);
                          }).toList(),
                        ),
                        floatingActionButton: FloatingActionButton(
                          elevation: 10.0,
                          onPressed: () {
                            openDialog(context);
                          },
                          // backgroundColor: Colors.amber,/
                          backgroundColor:
                              const Color.fromARGB(255, 47, 56, 85),

                          child: const Icon(
                            Icons.add,
                            color: Color.fromARGB(220, 225, 223, 216),
                          ),
                        ),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.endFloat,
                      );
                    }
                  }),
            ),
          );
        },
      ),
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
        context: navigatorKey.currentContext as BuildContext,
        builder: (context) => AlertDialog(
              title: const Text("Add Subject"),
              content: TextField(
                  controller: subjectController,
                  autofocus: true,
                  decoration:
                      const InputDecoration(hintText: "Enter Subject Name")),
              actions: [
                TextButton(
                    onPressed: () {
                      submitSubject(context, subjectController.text);
                      _subjectFuture = subjectRepository.getSubjects();
                    },
                    child: const Text('Submit'))
              ],
            ));
  }

  void submitSubject(BuildContext context, String subjectName) {
    var uuid = const Uuid();
    String subjectId = uuid.v4();
    Subjects newSubject =
        Subjects(id: subjectId, name: subjectName, chapters: []);

    subjectRepository.addSubject(newSubject);
    Navigator.of(context).pop();

    setState(() {});
  }

  void openEditDialog(BuildContext context, String id, String oldName) {
    editSubjectController.text = oldName;
    showDialog(
        context: navigatorKey.currentContext as BuildContext,
        builder: (context) => AlertDialog(
              title: const Text("Edit Subject Name"),
              content: TextField(
                  controller: editSubjectController,
                  autofocus: true,
                  decoration:
                      const InputDecoration(hintText: "Enter Subject Name")),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      editSubject(context, id, editSubjectController.text);
                      _subjectFuture = subjectRepository.getSubjects();
                    },
                    child: const Text('Submit'))
              ],
            ));
  }

  void editSubject(BuildContext context, String id, String subjectName) {
    subjectRepository.editSubject(id, subjectName);
    Navigator.of(context).pop();

    setState(() {
      _subjectFuture = subjectRepository.getSubjects();
    });
  }

  // Card for each subject
  Widget _buildGridItem(String id, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChaptersScreen(subjectId: id)));
      },
      child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            // color: Colors.orange.shade400,
            color: const Color.fromARGB(220, 142, 187, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(220, 244, 245, 252)),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: PopupMenuButton(
                    icon: const Icon(Icons.more_vert,
                        color: Color.fromARGB(220, 244, 245, 252)),
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
              )
            ],
          )),
    );
  }

  // dialog to confirm subject deletion
  void confirmDelete(BuildContext context, String id, String text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Confirmation"),
              content: RichText(
                  text: TextSpan(
                      text: "Are you sure you want to delete the subject : ",
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      children: <TextSpan>[
                    TextSpan(
                        text: text,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(text: " ?"),
                    const TextSpan(
                        text: "\nYou'll lose all existing flashcards.")
                  ])),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      subjectRepository.removeSubject(id);
                      Navigator.of(context).pop();
                      setState(() {
                        _subjectFuture = subjectRepository.getSubjects();
                      });
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }
}
