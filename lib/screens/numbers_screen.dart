import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../services/audio_service.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  static const _emojis = [
    '⭐', '🍎', '🐶', '🌸', '🎈',
    '🍦', '🐟', '🌙', '🦋', '🏆',
  ];

  final _random = Random();
  late List<int> _rounds;
  late List<String> _roundEmojis;
  late List<int> _options;
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedOption;
  late ConfettiController _confettiController;

  final List<Color> _buttonColors = [
    const Color(0xFFFF6B6B),
    const Color(0xFF38EF7D),
    const Color(0xFF667EEA),
    const Color(0xFFFFE66D),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _rounds = List.generate(10, (i) => i + 1)..shuffle(_random);
    final shuffledEmojis = List.of(_emojis)..shuffle(_random);
    _roundEmojis = shuffledEmojis;
    _generateOptions();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generateOptions() {
    final count = _rounds[_currentIndex];
    final wrong = List.generate(10, (i) => i + 1)
        .where((n) => n != count)
        .toList()
      ..shuffle(_random);
    _options = [count, ...wrong.take(3)]..shuffle(_random);
  }

  void _selectOption(int option) async {
    if (_answered) return;
    final count = _rounds[_currentIndex];
    final isCorrect = option == count;
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
      if (_currentIndex < _rounds.length - 1) {
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
            'total': _rounds.length,
            'category': 'Numbers',
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final count = _rounds[_currentIndex];
    final emoji = _roundEmojis[_currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4FACFE), Color(0xFFF09EBB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildProgress(),
                  const SizedBox(height: 10),
                  Text(
                    'How many $emoji do you see?',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Emoji display fills all remaining space
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 2),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: List.generate(
                                count,
                                (_) => Text(emoji,
                                    style:
                                        const TextStyle(fontSize: 34)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Fixed-height button row — never overflows
                  SizedBox(
                    height: 64,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(4, (index) {
                          final option = _options[index];
                          final isCorrect = option == count;
                          final isSelected = _selectedOption == option;

                          Color bgColor = _buttonColors[index];
                          if (_answered) {
                            if (isCorrect) bgColor = Colors.green;
                            else if (isSelected) bgColor = Colors.red;
                          }

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _selectOption(option),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius:
                                      BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: bgColor.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (_answered && isCorrect)
                                        const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 14),
                                      if (_answered &&
                                          isSelected &&
                                          !isCorrect)
                                        const Icon(Icons.cancel,
                                            color: Colors.white,
                                            size: 14),
                                      Text(
                                        '$option',
                                        style: const TextStyle(
                                          fontSize: 26,
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
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
              value: (_currentIndex + 1) / _rounds.length,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Round ${_currentIndex + 1} of ${_rounds.length}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
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
              'Numbers Game',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
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
              '$_score/${_rounds.length}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4FACFE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
