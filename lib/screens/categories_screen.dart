import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/category.dart';
import '../models/question.dart';
import '../services/audio_service.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const _quizColors = [
    Color(0xFFFF6B6B),
    Color(0xFF38EF7D),
    Color(0xFF667EEA),
    Color(0xFFFFE66D),
    Color(0xFFFF922B),
    Color(0xFFE84393),
  ];

  static const _gameColors = [
    Color(0xFFFF9A9E),
    Color(0xFF43E97B),
    Color(0xFF4FACFE),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildGrid(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 26),
            ),
          ),
          const Expanded(
            child: Text(
              'Choose a Category',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final quizCats = categories.where((c) => c.gameRoute == null).toList();
    final gameCats = categories.where((c) => c.gameRoute != null).toList();

    return LayoutBuilder(
      builder: (ctx, constraints) {
        const hPad = 12.0;
        const gap = 8.0;
        const labelH = 18.0;
        // vertical budget:
        // vPad(6) + label + gap + row + gap + row + gap + row + gap +
        //           label + gap + gameRow + vPad(6)
        // = 12 + 2*(labelH+gap) + 3*(gap) + 4*cardH
        const fixedV = 12.0 + 2 * (labelH + gap) + 3 * gap;
        final cardH =
            ((constraints.maxHeight - fixedV) / 4).clamp(48.0, 160.0);
        final quizW = (constraints.maxWidth - 2 * hPad - gap) / 2;
        final gameW = (constraints.maxWidth - 2 * hPad - 2 * gap) / 3;
        final emojiSz = (cardH * 0.38).clamp(20.0, 52.0);
        final fontSz = (cardH * 0.12).clamp(9.0, 15.0);

        Widget buildCard(Category cat, Color color, double w,
            {bool isGame = false}) {
          return GestureDetector(
            onTap: () => _navigate(context, cat),
            child: Container(
              width: w,
              height: cardH,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat.icon,
                            style: TextStyle(fontSize: emojiSz)),
                        SizedBox(height: cardH * 0.05),
                        Text(
                          cat.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSz,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isGame)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'GAME',
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        Widget quizRow(int start) {
          return SizedBox(
            height: cardH,
            child: Row(children: [
              buildCard(quizCats[start], _quizColors[start], quizW),
              const SizedBox(width: gap),
              buildCard(
                  quizCats[start + 1], _quizColors[start + 1], quizW),
            ]),
          );
        }

        Widget label(String text) {
          return SizedBox(
            height: labelH,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black26, offset: Offset(1, 1))
                ],
              ),
            ),
          );
        }

        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: hPad, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label('📚 Quiz Categories'),
              const SizedBox(height: gap),
              quizRow(0),
              const SizedBox(height: gap),
              quizRow(2),
              const SizedBox(height: gap),
              quizRow(4),
              const SizedBox(height: gap),
              label('🎮 Mini Games'),
              const SizedBox(height: gap),
              SizedBox(
                height: cardH,
                child: Row(
                  children: [
                    buildCard(gameCats[0], _gameColors[0], gameW,
                        isGame: true),
                    const SizedBox(width: gap),
                    buildCard(gameCats[1], _gameColors[1], gameW,
                        isGame: true),
                    const SizedBox(width: gap),
                    buildCard(gameCats[2], _gameColors[2], gameW,
                        isGame: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigate(BuildContext context, Category category) {
    AudioService().playClickSound();
    if (category.gameRoute != null) {
      Navigator.pushNamed(context, category.gameRoute!);
      return;
    }
    final shuffled = List<Question>.from(category.questions)..shuffle();
    Navigator.pushNamed(
      context,
      '/quiz',
      arguments: {
        'category': category,
        'questions': shuffled.take(5).toList(),
      },
    );
  }
}
