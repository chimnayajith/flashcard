import 'package:flashcard/screens/subject_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildPage(
                  'Welcome to RecallX',
                  'Your Shortcut to Smarter Learning.',
                  './lib/assets/logo.png',
                  0.5),
              _buildPage(
                  'Promotes Active Recall',
                  'Flashcards help students to engage in Active Recall',
                  './lib/assets/study.png',
                  0.8),
              _buildPage(
                  'Effortless Organisation',
                  'Easily categorize your study materials by subjects, break them down into chapters, and create flashcards for each topic with RecallX ',
                  './lib/assets/organise.png',
                  0.8),
              _buildPage(
                  'Interactive Learning',
                  'Swipe through flashcards and tap to reveal answers, making learning engaging and dynamic. ',
                  './lib/assets/interactive.png',
                  0.8),
            ],
          ),
          if (_currentIndex < 3)
            Positioned(
              top: 50,
              right: 10,
              child: TextButton(
                child: const Text(
                  'Skip',
                  style: TextStyle(
                      color: Color.fromARGB(220, 147, 177, 166), fontSize: 14),
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                    _pageController.jumpToPage(3);
                  });
                },
              ),
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
                onPressed: () async {
                  if (_currentIndex < 3) {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  } else {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isFirstTime', false);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubjectScreen()));
                  }
                },
                child: Text(_currentIndex < 3 ? "Next" : "Get Started")),
          ),
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width / 2 - 60,
            child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: 4,
                effect: const ExpandingDotsEffect()),
          )
        ],
      ),
    );
  }

  Widget _buildPage(String title, String content, String image, double scale) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(scale: scale, child: Image.asset(image)),
          Text(
            title,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
        ],
      ),
    )));
  }
}
