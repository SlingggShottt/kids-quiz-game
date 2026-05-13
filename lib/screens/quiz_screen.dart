import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/category.dart';
import '../models/question.dart';
import '../services/audio_service.dart';
import '../widgets/quiz_image.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Category? _category;
  List<Question>? _questions;
  int _currentIndex = 0;
  int _score = 0;
  bool _showResult = false;
  bool _selected = false;
  String? _selectedAnswer;
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
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_category == null) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _category =
          args?['category'] as Category? ?? _createDefaultCategory();
      _questions =
          args?['questions'] as List<Question>? ?? _category!.questions;
    }
  }

  Category _createDefaultCategory() {
    return Category(name: 'Quiz', icon: '❓', questions: []);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectAnswer(String answer) async {
    if (_selected) return;

    setState(() {
      _selected = true;
      _selectedAnswer = answer;
      _showResult = true;
    });

    final isCorrect = answer == _questions![_currentIndex].correctAnswer;
    if (isCorrect) {
      _score++;
      await AudioService().playCorrectSound();
      _confettiController.play();
    } else {
      await AudioService().playWrongSound();
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (!mounted) return;

    if (_currentIndex < _questions!.length - 1) {
      setState(() {
        _currentIndex++;
        _showResult = false;
        _selected = false;
        _selectedAnswer = null;
      });
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/results',
        arguments: {
          'score': _score,
          'total': _questions!.length,
          'category': _category!.name,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions == null || _category == null) {
      return _buildGradientScaffold(
        child: const Center(
            child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_questions!.isEmpty) {
      return _buildGradientScaffold(
        child: const Center(
          child: Text('No questions available',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      );
    }

    final currentQuestion = _questions![_currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          _buildGradientScaffold(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildProgress(),
                  Expanded(child: _buildQuestionContent(currentQuestion)),
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

  Widget _buildGradientScaffold({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
          ),
          const Expanded(
            child: Text(
              'Quiz Time!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '$_score/${_questions!.length}',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4FACFE)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_category!.icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                _category!.name,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions!.length,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Question ${_currentIndex + 1} of ${_questions!.length}',
            style: TextStyle(
                fontSize: 11, color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(Question question) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final availableWidth = constraints.maxWidth;
        final imageSize = (availableHeight * 0.32).clamp(90.0, 200.0);
        final fontSize = (availableWidth * 0.038).clamp(13.0, 18.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ── Real asset image with pop-in animation ─────────────────
              // ValueKey(_currentIndex) forces a full rebuild + re-animation
              // every time the question changes.
              QuizImage(
                key: ValueKey(_currentIndex),
                imagePath: question.imageName,
                category: _category!.name.toLowerCase(),
                size: imageSize,
              ),

              // ── Question prompt ────────────────────────────────────────
              Text(
                'What is this?',
                style: TextStyle(
                  fontSize: (availableWidth * 0.055).clamp(16.0, 24.0),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // ── 2 × 2 answer buttons ───────────────────────────────────
              _buildAnswerGrid(question, fontSize, availableHeight),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnswerGrid(
      Question question, double fontSize, double availableHeight) {
    final buttonHeight = (availableHeight * 0.17).clamp(44.0, 68.0);
    const gap = 8.0;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          _buildAnswerRow(question, [0, 1], buttonHeight, gap, fontSize),
          const SizedBox(height: gap),
          _buildAnswerRow(question, [2, 3], buttonHeight, gap, fontSize),
        ],
      ),
    );
  }

  Widget _buildAnswerRow(Question question, List<int> indices, double height,
      double gap, double fontSize) {
    return Row(
      children: indices.map((index) {
        if (index >= question.options.length) {
          return const Expanded(child: SizedBox());
        }

        final option = question.options[index];
        final isCorrect = option == question.correctAnswer;
        final isSelected = _selectedAnswer == option;
        final isFirst = index == indices.first;

        Color bgColor = _buttonColors[index % _buttonColors.length];
        if (_showResult) {
          bgColor = isCorrect
              ? Colors.green
              : (isSelected ? Colors.red : bgColor);
        }

        return Expanded(
          child: GestureDetector(
            onTap: () => _selectAnswer(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: height,
              margin: EdgeInsets.only(
                left: isFirst ? 0 : gap / 2,
                right: isFirst ? gap / 2 : 0,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_showResult && isCorrect)
                    const Icon(Icons.check_circle,
                        color: Colors.white, size: 18),
                  if (_showResult && isSelected && !isCorrect)
                    const Icon(Icons.cancel, color: Colors.white, size: 18),
                  if (_showResult) const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
