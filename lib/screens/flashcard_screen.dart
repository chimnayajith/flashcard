import 'package:flashcard/components/custom_snackbar.dart';
import 'package:flashcard/models/flashcard_model.dart';
import 'package:flashcard/repositories/flashcard_repository.dart';
import 'package:flashcard/screens/add_flashcard_screen.dart';
import 'package:flashcard/screens/chapters_screen.dart';
import 'package:flashcard/screens/edit_flashcard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_tex/flutter_tex.dart';

class FlashcardScreen extends StatefulWidget {
  final String subjectId;
  final String chapterName;

  const FlashcardScreen(
      {Key? key, required this.subjectId, required this.chapterName})
      : super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  late Future<List<Flashcard>> _flashcardFuture;
  final FlashcardRepository flashcardRepository = FlashcardRepository();
  late List<Flashcard> _flashcards;
  int _currentIndex = 0;
  final List _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.cyan,
  ];
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _flashcardFuture =
        flashcardRepository.getFlashcards(widget.subjectId, widget.chapterName);
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChaptersScreen(subjectId: widget.subjectId)));
        return true;
      },
      child: FutureBuilder(
          future: _flashcardFuture,
          builder: (context, AsyncSnapshot<List<Flashcard>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error ${snapshot.error}');
            } else {
              _flashcards = snapshot.data!;
              return Scaffold(
                  appBar: AppBar(
                    title: Text(widget.chapterName),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddFlashCardScreen(
                                          subjectId: widget.subjectId,
                                          chapterName: widget.chapterName,
                                        )));
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 30,
                          ))
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(
                          child: _flashcards.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('./lib/assets/empty.png'),
                                    const Text(
                                      'No flashcards yet!',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 244, 245, 252)),
                                    ),
                                    const Text(
                                      'Add using the + icon.',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    )
                                  ],
                                )
                              : PageView.builder(
                                  itemCount: _flashcards.length,
                                  controller: _controller,
                                  onPageChanged: (i) {
                                    setState(() {
                                      _currentIndex = i;
                                    });
                                  },
                                  itemBuilder: (context, i) {
                                    return AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        double value = 1.0;
                                        if (_controller
                                            .position.haveDimensions) {
                                          value = _controller.page! - i;
                                          value = (1 - (value.abs() * 0.5))
                                              .clamp(0.0, 1.0);
                                        }
                                        return Center(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 50),
                                              child: SizedBox(
                                                width: Curves.easeOut
                                                        .transform(value) *
                                                    350,
                                                height: Curves.easeOut
                                                        .transform(value) *
                                                    550,
                                                child: child,
                                              )),
                                        );
                                      },
                                      child: GestureDetector(
                                          onHorizontalDragEnd: (details) {
                                            if (details.primaryVelocity! > 0) {
                                              prevCard();
                                            } else {
                                              nextCard();
                                            }
                                          },
                                          child: FlipCard(
                                              side: CardSide.FRONT,
                                              front: Card(
                                                  elevation: 5,
                                                  color: _colors[(i) % 5],
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                          child: Text(
                                                              _flashcards[i]
                                                                  .question,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          20))),
                                                      const Positioned(
                                                          top: 20,
                                                          left: 20,
                                                          child: Text(
                                                            "Question",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          )),
                                                      Positioned(
                                                          top: 20,
                                                          right: 20,
                                                          child: Text(
                                                              '${i + 1} / ${_flashcards.length}',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18))),
                                                      const Positioned(
                                                          left: 135,
                                                          bottom: 10,
                                                          child: Text(
                                                            'Tap to flip',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 14),
                                                          ))
                                                    ],
                                                  )),
                                              back: Card(
                                                  elevation: 5,
                                                  color: _colors[(i) % 5],
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                          child: _flashcards[i]
                                                                      .type ==
                                                                  "normal"
                                                              ? Text(
                                                                  _flashcards[i]
                                                                      .answer,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20))
                                                              : TeXView(
                                                                  child: TeXViewDocument(
                                                                      _flashcards[
                                                                              i]
                                                                          .complexAnswer,
                                                                      style: const TeXViewStyle(
                                                                          textAlign:
                                                                              TeXViewTextAlign.center)))),
                                                      const Positioned(
                                                          top: 10,
                                                          left: 10,
                                                          child: Text(
                                                            "Answer",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          )),
                                                      Positioned(
                                                          top: 10,
                                                          right: 10,
                                                          child: Text(
                                                            '${i + 1} / ${_flashcards.length}',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          )),
                                                      const Positioned(
                                                          left: 135,
                                                          bottom: 10,
                                                          child: Text(
                                                            'Tap to flip',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 14),
                                                          ))
                                                    ],
                                                  )))),
                                    );
                                  })),
                      if (_flashcards.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: AnimatedSmoothIndicator(
                            activeIndex: _currentIndex,
                            count: _flashcards.length,
                            effect: const ScrollingDotsEffect(
                                dotHeight: 8.0, dotWidth: 8.0),
                          ),
                        ),
                      if (_flashcards.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 40, right: 30, left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 47, 56, 85),
                                radius: 30,
                                child: IconButton(
                                    onPressed: () {
                                      prevCard();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                              ),
                              CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 47, 56, 85),
                                radius: 30,
                                child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(40))),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 200,
                                              color: Colors.grey.shade900,
                                              child: Center(
                                                child: Column(children: [
                                                  Container(
                                                    height: 50,
                                                    child: const Center(
                                                      child: Text(
                                                          "Flashcard Options",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      244,
                                                                      245,
                                                                      252),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          EditFlashcardScreen(
                                                                            flashcard:
                                                                                _flashcards[_currentIndex],
                                                                          )));
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade900,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .zero,
                                                              ),
                                                            ),
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: double
                                                                    .infinity,
                                                                height: 50,
                                                                child: const Text(
                                                                    "Edit",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white))),
                                                          ),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                flashcardRepository.deleteFlashcard(
                                                                    widget
                                                                        .subjectId,
                                                                    widget
                                                                        .chapterName,
                                                                    _flashcards[
                                                                            _currentIndex]
                                                                        .question,
                                                                    _flashcards[
                                                                            _currentIndex]
                                                                        .answer);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                refreshData();
                                                                showSuccessSnackBar(
                                                                    context,
                                                                    "Flashcard deleted!");
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors.grey
                                                                        .shade900,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .zero,
                                                                ),
                                                              ),
                                                              child: Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: double
                                                                      .infinity,
                                                                  height: 50,
                                                                  child:
                                                                      const Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ))),
                                                        ]),
                                                  )
                                                ]),
                                              ),
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    )),
                              ),
                              CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 47, 56, 85),
                                radius: 30,
                                child: IconButton(
                                    onPressed: () {
                                      nextCard();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        )
                    ],
                  ));
            }
          }),
    );
  }

  void refreshData() {
    setState(() {
      _flashcardFuture = flashcardRepository.getFlashcards(
          widget.subjectId, widget.chapterName);
    });
  }

  void prevCard() {
    setState(() {
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  void nextCard() {
    setState(() {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }
}
