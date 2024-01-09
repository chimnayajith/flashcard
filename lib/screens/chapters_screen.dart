import 'package:flashcard/models/subject_model.dart';
import 'package:flashcard/screens/flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashcard/repositories/subject_repository.dart';


class ChaptersScreen extends StatefulWidget {
  final String subjectId;

  const ChaptersScreen({Key? key, required this.subjectId}) : super(key: key);

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {

  late Future<Subjects?> _subjectFuture;
  final SubjectRepository subjectRepository = SubjectRepository();

  final navigatorKey = GlobalKey<NavigatorState>();

  final TextEditingController chapterController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _subjectFuture = subjectRepository.getSubjectById(widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _subjectFuture, 
      builder: (context , AsyncSnapshot<Subjects?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if ( snapshot.hasError){
          return Text('Error ${snapshot.error}');
        } else {
          Subjects subject = snapshot.data!;
          List<String> chapters = subject.chapters;
          return Scaffold(
            appBar: AppBar(
              title: Text('Chapters - ${subject.name}',
              textAlign: TextAlign.left,)
            ),
            body: ListView(
              padding : const EdgeInsets.all(10),
              children: chapters.isNotEmpty
                  ? chapters.map((each) {
                      return _buildCard(subject.id , each);
                    }).toList()
                  : [ 
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('./lib/assets/empty_dark.png'),
                        const Text(
                          'No chapters yet!',
                          style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold , color: Colors.white),
                          ),
                        const Text(
                          'Add using the + icon.',
                          style: TextStyle(fontSize: 16 , color: Colors.grey),
                          )
                      ],
                    )
                    ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  openDialog(context , subject.id);
                },
                backgroundColor: Colors.amber,
                child: const Icon(Icons.add),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            );
        }
      }
      );
  }

  void openDialog(BuildContext context, String id) {
    showDialog(
      context:context,
      builder: (context) => AlertDialog(
        title: const Text("Add Chapter"),
        content:  TextField(
          controller: chapterController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Enter Chapter Name")
          ),
          contentPadding: const EdgeInsets.all(20),
        actions: [
          TextButton(
            onPressed: (){submitChapter(context , id , chapterController.text);}, 
            child: const Text('Submit')
            )
        ],
      )
  );
}

void submitChapter(BuildContext context,String subjectId , String chapterName) {
  subjectRepository.addChapterToSubject(subjectId , chapterName);
  Navigator.of(context).pop();

  setState(() {
    _subjectFuture = subjectRepository.getSubjectById(widget.subjectId);
  });
}

    Widget _buildCard(String id ,String text) {
    return GestureDetector(
      onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FlashcardScreen(subjectId:id , chapterName : text))
          );
      },
    child: Card(
      child: ListTile(
        title: Text(text),
        trailing: IconButton(
          icon : const Icon(Icons.delete),
          onPressed: (){
            confirmDelete(context, id, text);
          },
        ),
      ),
      ),
      );
    }

    // dialog to confirm chapter deletion
  void confirmDelete (BuildContext context, String id , String text) {
    showDialog(
      context:context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmation"),
        content: RichText(
          text:TextSpan(
            text: "Are you sure you want to delete the chapter : ",
            style: const TextStyle(fontSize: 20 , color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: text,
                style: const TextStyle(fontWeight: FontWeight.bold)
              ),
              const TextSpan(text: " ?")
            ]
          ) 
          ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(false); 
            }, child: const Text('Cancel')),
          TextButton(
            onPressed: (){
                subjectRepository.removeChapterFromSubject(id, text);
                Navigator.of(context).pop();
                setState(() {
                  _subjectFuture = subjectRepository.getSubjectById(widget.subjectId);
                });
              }, 
            child: const Text('Confirm', style: TextStyle(color: Colors.red),)
            ),
        ],
      )
  );
}
}


