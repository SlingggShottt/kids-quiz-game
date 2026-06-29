import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../services/audio_service.dart';

class SpotTheDifferenceScreen extends StatefulWidget {
  const SpotTheDifferenceScreen({super.key});

  @override
  State<SpotTheDifferenceScreen> createState() =>
      _SpotTheDifferenceScreenState();
}

class _SpotTheDifferenceScreenState extends State<SpotTheDifferenceScreen> {
  // Each pair: (main emoji, odd emoji) — kept in completely different
  // visual categories so they're unmistakable even at small grid sizes.
  static const _emojiPairs = [
    ('🐶', '🍕'),  // dog  vs pizza
    ('⭐', '🍎'),  // star vs apple
    ('🚗', '❤️'),  // car  vs heart
    ('🐱', '🏠'),  // cat  vs house
    ('🎈', '✈️'),  // ball vs plane
    ('🐸', '🎃'),  // frog vs pumpkin
    ('🍦', '🌙'),  // ice  vs moon
    ('🐧', '🍰'),  // bird vs cake
    ('🌸', '🚂'),  // flwr vs train
    ('🐻', '🎵'),  // bear vs note
  ];

  final _random = Random();
  int _round = 0;
  int _score = 0;
  bool _answered = false;
  int _oddIndex = 0;
  int _tappedIndex = -1;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    _oddIndex = _random.nextInt(16);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _onTap(int index) async {
    if (_answered) return;
    final isCorrect = index == _oddIndex;
    setState(() {
      _answered = true;
      _tappedIndex = index;
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
      if (_round < 9) {
        setState(() {
          _round++;
          _answered = false;
          _tappedIndex = -1;
          _oddIndex = _random.nextInt(16);
        });
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/results',
          arguments: {
            'score': _score,
            'total': 10,
            'category': 'Spot the Difference',
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainEmoji = _emojiPairs[_round].$1;
    final oddEmoji = _emojiPairs[_round].$2;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9A9E), Color(0xFFA18CD1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (_round + 1) / 10,
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Round ${_round + 1} of 10',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '🔍 Tap the odd one out!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const spacing = 8.0;
                          // Compute cell size so 4×4 fills the available box
                          final cellW =
                              (constraints.maxWidth - 3 * spacing) / 4;
                          final cellH =
                              (constraints.maxHeight - 3 * spacing) / 4;
                          final ratio = cellW / cellH;
                          final emojiSz =
                              (cellW < cellH ? cellW : cellH) * 0.48;

                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: spacing,
                              crossAxisSpacing: spacing,
                              // ratio > 1 on wide screens → cells are wider
                              // than tall, keeping all 4 rows visible
                              childAspectRatio: ratio,
                            ),
                            itemCount: 16,
                            itemBuilder: (context, index) {
                              final isOdd = index == _oddIndex;
                              final emoji = isOdd ? oddEmoji : mainEmoji;

                              Color bgColor =
                                  Colors.white.withOpacity(0.25);
                              if (_answered) {
                                if (index == _oddIndex) {
                                  bgColor = Colors.green.withOpacity(0.8);
                                } else if (index == _tappedIndex) {
                                  bgColor = Colors.red.withOpacity(0.7);
                                }
                              }

                              return GestureDetector(
                                onTap: () => _onTap(index),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      emoji,
                                      style: TextStyle(
                                        fontSize:
                                            emojiSz.clamp(14.0, 40.0),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.orange,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          const Expanded(
            child: Text(
              'Spot the Difference',
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
              '$_score/10',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9A9E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
