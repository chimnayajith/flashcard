import 'package:flashcard/models/flashcard_model.dart';
import 'package:flashcard/repositories/flashcard_repository.dart';
import 'package:flashcard/screens/add_flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FlashcardScreen extends StatefulWidget {

  final String subjectId;
  final String chapterName;

  const FlashcardScreen({Key? key , required this.subjectId , required this.chapterName}):super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {

  late Future<List<Flashcard>> _flashcardFuture;
  final FlashcardRepository flashcardRepository = FlashcardRepository();
  
  @override
  void initState() {
    super.initState();
    _flashcardFuture = flashcardRepository.getFlashcards(widget.subjectId , widget.chapterName);
  }

  final List<Flashcard> _dummy = [
    Flashcard(
        subjectId:'13a96cf7-47fe-4d52-880b-e5c25a1c3d14',
        chapter:'meh',
        type: 'Normal',
        question: "What programming language does Flutter use?",
        answer: "Dart"
      ),
    Flashcard(
        subjectId:'13a96cf7-47fe-4d52-880b-e5c25a1c3d14',
        chapter:'meh',
        type: 'Normal', 
        question: "Who you gonna call?", 
        answer: "Ghostbusters!"
      ),
    Flashcard(
        subjectId:'13a96cf7-47fe-4d52-880b-e5c25a1c3d14',
        chapter:'meh',
        type: 'Normal', 
        question: "Who teaches you how to write sexy code?",
        answer: "Ya boi Kilo Loco!"
      )
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _flashcardFuture, 
      builder: (context , AsyncSnapshot <List<Flashcard>> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if ( snapshot.hasError){
          return Text('Error ${snapshot.error}');
        } else {
          // List<Flashcard> flashcards = snapshot.data!;
           return Scaffold(
            appBar: AppBar(
              title: const Text('Flashcards'),
              actions: [
                IconButton(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => AddFlashCardScreen(subjectId : widget.subjectId , chapterName : widget.chapterName))
                      );                      
                  }, 
                  icon: const Icon(Icons.add)
                  )
              ],
            ),
            body : GestureDetector(
              onHorizontalDragEnd: (details) {
                if(details.primaryVelocity! > 0){
                  prevCard();
                } else {
                  nextCard();
                }
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 350,
                      height: 500,
                      child : FlipCard(
                        side: CardSide.FRONT,
                        front: Card(
                          elevation: 5,
                          child: Center(
                              child:Text(_dummy[_currentIndex].question , textAlign: TextAlign.center)
                            )
                        ),
                        back: Card(
                          elevation: 5,
                            child: Center(
                              child:Text(_dummy[_currentIndex].answer , textAlign: TextAlign.center)
                            )
                          ),
                        )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      OutlinedButton.icon(onPressed: prevCard, icon: const Icon(Icons.arrow_left), label: const Text('Prev')),
                      Text('${_currentIndex + 1} / ${_dummy.length}' , style: const TextStyle(color: Colors.white),),
                      OutlinedButton.icon(onPressed: nextCard, icon: const Icon(Icons.arrow_right), label: const Text('Next')),
                    ],)
                  ],
                ),
            ),
            )
           );
        }
      }
      );
  }




  void prevCard(){
    setState((){
      _currentIndex = (_currentIndex -1 >= 0) ? _currentIndex-1 : _dummy.length -1 ;
    });
  }


  void nextCard(){
    setState(() {
      _currentIndex = (_currentIndex+1 < _dummy.length) ? _currentIndex +1 : 0;
    });
  }
}