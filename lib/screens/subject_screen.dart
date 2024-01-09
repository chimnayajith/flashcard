import 'package:flashcard/models/subject_model.dart';
import 'package:flashcard/repositories/subject_repository.dart';
import 'package:flashcard/screens/chapters_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen>  {
  final navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController subjectController = TextEditingController();

  final SubjectRepository subjectRepository = SubjectRepository();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings){
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
                title: const Text('Subjects'),
              ),
            body: FutureBuilder(
              future: subjectRepository.getSubjects(), 
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                } else if ( snapshot.hasError) {
                  return Text('Error ${snapshot.error}');
                } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return Scaffold(
                    body:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('./lib/assets/empty.jpg'),
                        const Text(
                          'No subjects yet!',
                          style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),
                          ),
                        const Text(
                          'Add using the + icon.',
                          style: TextStyle(fontSize: 16 , color: Colors.grey),
                          )
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        openDialog(context);
                      },
                      backgroundColor: Colors.amber,
                      child: const Icon(Icons.add),
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                        return _buildGridItem(subject.id ,subject.name);
                      }).toList(),
                    ),
                    floatingActionButton: FloatingActionButton(
                      elevation: 10.0,
                      onPressed: () {
                        openDialog(context);
                      },
                      backgroundColor: Colors.amber,
                      child: const Icon(Icons.add),
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                  );
                }
            }),
            
          ),     
    );
      },
    );
  }

void openDialog(BuildContext context) {
    showDialog(
      context:navigatorKey.currentContext as BuildContext,
      builder: (context) => AlertDialog(
        title: const Text("Add Subject"),
        content:  TextField(
          controller: subjectController,
          autofocus: true,
          decoration: const InputDecoration(hintText: "Enter Subject Name")
          ),
        actions: [
          TextButton(
            onPressed: (){submitSubject(context , subjectController.text);}, 
            child: const Text('Submit')
            )
        ],
      )
  );
}


void submitSubject(BuildContext context, String subjectName) {
  var uuid = const Uuid();
  String subjectId = uuid.v4();
  Subjects newSubject = Subjects(id:subjectId , name: subjectName , chapters : []);

  subjectRepository.addSubject(newSubject);
  Navigator.of(context).pop();

  setState(() {});
}

Widget _buildGridItem(String id , String text) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChaptersScreen(subjectId : id))
        );
    },
    onLongPress: () {
      // open delte option.
    },
    child : Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold , color: Colors.white),
        ),
      ),
  ),
  );
}

}
