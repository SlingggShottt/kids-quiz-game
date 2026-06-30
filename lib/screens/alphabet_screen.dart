import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../services/audio_service.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  static const _allLetters = [
    ('A', '🍎', 'Apple'),
    ('B', '🦋', 'Butterfly'),
    ('C', '🐱', 'Cat'),
    ('D', '🐶', 'Dog'),
    ('E', '🐘', 'Elephant'),
    ('F', '🐟', 'Fish'),
    ('G', '🦒', 'Giraffe'),
    ('H', '🏠', 'House'),
    ('I', '🍦', 'Ice Cream'),
    ('J', '🃏', 'Joker'),
    ('K', '🔑', 'Key'),
    ('L', '🦁', 'Lion'),
    ('M', '🐵', 'Monkey'),
    ('N', '🎵', 'Note'),
    ('O', '🐙', 'Octopus'),
    ('P', '🐧', 'Penguin'),
    ('Q', '👸', 'Queen'),
    ('R', '🐇', 'Rabbit'),
    ('S', '🐍', 'Snake'),
    ('T', '🐯', 'Tiger'),
    ('U', '☂️', 'Umbrella'),
    ('V', '🎻', 'Violin'),
    ('W', '🐋', 'Whale'),
    ('X', '❌', 'X Mark'),
    ('Y', '💛', 'Yellow'),
    ('Z', '🦓', 'Zebra'),
  ];

  static const _optionColors = [
    Color(0xFFFF6B6B),
    Color(0xFF38EF7D),
    Color(0xFF667EEA),
    Color(0xFFFFE66D),
  ];

  final _random = Random();
  late List<(String, String, String)> _questions;
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedOption;
  late List<String> _options;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    final shuffled = List.of(_allLetters)..shuffle(_random);
    _questions = shuffled.take(10).toList();
    _generateOptions();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generateOptions() {
    final correctLetter = _questions[_currentIndex].$1;
    final allChars = _allLetters.map((e) => e.$1).toList();
    final wrong = allChars.where((l) => l != correctLetter).toList()
      ..shuffle(_random);
    _options = [correctLetter, ...wrong.take(3)]..shuffle(_random);
  }

  void _selectOption(String option) async {
    if (_answered) return;
    final correctLetter = _questions[_currentIndex].$1;
    final isCorrect = option == correctLetter;
    setState(() {
      _answered = true;
      _selectedOption = option;
      if (isCorrect) _score++;
    });

    if (isCorrect) {
      await AudioService().playCorrectSound();
      _confettiController.play();
    } else {
      await AudioService().playWrongSound();
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _selectedOption = null;
        });
        _generateOptions();
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/results',
          arguments: {
            'score': _score,
            'total': _questions.length,
            'category': 'Alphabet',
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final correctLetter = question.$1;
    final emoji = question.$2;
    final word = question.$3;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildProgress(),
                  // Expanded keeps everything in the remaining space — no overflow
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                      child: Column(
                        children: [
                          // Question card — flex 3 (larger share)
                          Expanded(
                            flex: 3,
                            child: _buildQuestionCard(emoji, word),
                          ),
                          const SizedBox(height: 12),
                          // Letter options — flex 2 (smaller share)
                          Expanded(
                            flex: 2,
                            child: _buildOptions(correctLetter),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red, Colors.yellow, Colors.green,
                Colors.blue, Colors.orange, Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              minHeight: 12,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Question ${_currentIndex + 1} of ${_questions.length}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String emoji, String word) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: Colors.white.withOpacity(0.5), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji scales with available height
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(emoji, style: const TextStyle(fontSize: 90)),
          ),
          const SizedBox(height: 8),
          Text(
            word,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Which letter does "$word" start with?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2×2 grid built from Rows so it works inside Expanded without shrinkWrap
  Widget _buildOptions(String correctLetter) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _optionBtn(_options[0], correctLetter, 0),
              const SizedBox(width: 10),
              _optionBtn(_options[1], correctLetter, 1),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              _optionBtn(_options[2], correctLetter, 2),
              const SizedBox(width: 10),
              _optionBtn(_options[3], correctLetter, 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _optionBtn(String option, String correctLetter, int colorIndex) {
    final isCorrect = option == correctLetter;
    final isSelected = _selectedOption == option;

    Color bgColor = _optionColors[colorIndex];
    if (_answered) {
      if (isCorrect) bgColor = Colors.green.withOpacity(0.9);
      else if (isSelected) bgColor = Colors.red.withOpacity(0.85);
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => _selectOption(option),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Colors.white.withOpacity(0.6), width: 2),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_answered && isCorrect)
                  const Icon(Icons.check_circle,
                      color: Colors.white, size: 32),
                if (_answered && isSelected && !isCorrect)
                  const Icon(Icons.cancel,
                      color: Colors.white, size: 32),
                if (_answered) const SizedBox(width: 6),
                Text(
                  option,
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              AudioService().playClickSound();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back,
                  color: Colors.white, size: 24),
            ),
          ),
          const Expanded(
            child: Text(
              'Alphabet Game',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '$_score/${_questions.length}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF43E97B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
