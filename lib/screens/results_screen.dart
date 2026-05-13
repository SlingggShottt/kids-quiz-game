import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scoreAnimation;
  // clampedStar stays in [0,1] — fixes the Opacity assertion from elasticOut
  // overshooting negative values.
  late Animation<double> _starAnimation;
  late Animation<double> _clampedStar;

  bool _celebrationPlayed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _starAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    // Clamped version used wherever we feed into Opacity / Transform.scale,
    // which both require values in [0, 1].
    _clampedStar = _starAnimation.drive(
      Tween<double>(begin: 0.0, end: 1.0),
    );

    _controller.forward();

    // Play celebration after a short delay — on mobile this works fine.
    // On Chrome it will silently fail until the user has interacted; that's
    // expected browser behaviour and not a bug we can work around.
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && !_celebrationPlayed) {
        _celebrationPlayed = true;
        AudioService().playCelebrationSound();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Route arguments ───────────────────────────────────────────────────────

  Map<String, dynamic> get _args =>
      (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
      {};

  int get _score => (_args['score'] as int?) ?? 0;
  int get _total => (_args['total'] as int?) ?? 1;
  String get _category => (_args['category'] as String?) ?? '';
  double get _percentage => _total > 0 ? _score / _total : 0;

  String get _message {
    if (_percentage == 1.0) return 'Perfect! 🏆';
    if (_percentage >= 0.8) return 'Amazing! ⭐';
    if (_percentage >= 0.6) return 'Great Job! 👍';
    if (_percentage >= 0.4) return 'Good Try! 💪';
    return 'Keep Practicing! 📚';
  }

  String get _emoji {
    if (_percentage == 1.0) return '🏆';
    if (_percentage >= 0.8) return '🌟';
    if (_percentage >= 0.6) return '😊';
    if (_percentage >= 0.4) return '🙂';
    return '💪';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getGradientColors(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                // SingleChildScrollView prevents overflow on very small screens
                // while still filling the screen on normal phones.
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        _buildEmojiCircle(),
                        const SizedBox(height: 24),
                        _buildMessage(),
                        const SizedBox(height: 16),
                        _buildScoreCard(),
                        const SizedBox(height: 24),
                        _buildStars(),
                        const SizedBox(height: 32),
                        _buildButtons(constraints.maxWidth),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiCircle() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Center(
          child: Text(_emoji, style: const TextStyle(fontSize: 70)),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        _message,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        // easeOut never goes negative, so this is safe
        return Opacity(opacity: _scoreAnimation.value, child: child);
      },
      child: Column(
        children: [
          if (_category.isNotEmpty)
            Text(
              _category,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$_score / $_total',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4FACFE),
                  ),
                ),
                Text(
                  'Correct Answers',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars() {
    return AnimatedBuilder(
      animation: _clampedStar,
      builder: (context, child) {
        final v = _clampedStar.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: v,
          child: Transform.scale(scale: v, child: child),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final filled = index < (_percentage * 3).round();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              filled ? Icons.star : Icons.star_border,
              size: 48,
              color: filled
                  ? const Color(0xFFFFE66D)
                  : Colors.white.withOpacity(0.5),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildButtons(double screenWidth) {
    // Button fills available width up to 280, so "Choose Category" never clips
    final buttonWidth = (screenWidth - 48).clamp(0.0, 280.0);

    return AnimatedBuilder(
      animation: _clampedStar,
      builder: (context, child) {
        final v = _clampedStar.value.clamp(0.0, 1.0);
        return Opacity(opacity: v, child: child);
      },
      child: Column(
        children: [
          _buildButton(
            text: 'Play Again',
            icon: Icons.replay,
            color: const Color(0xFF4FACFE),
            width: buttonWidth,
            onTap: () {
              AudioService().playClickSound();
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _buildButton(
            text: 'Choose Category',
            icon: Icons.list,
            color: const Color(0xFFFFE66D),
            width: buttonWidth,
            onTap: () {
              AudioService().playClickSound();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _buildButton(
            text: 'Home',
            icon: Icons.home,
            color: const Color(0xFFFF6B6B),
            width: buttonWidth,
            onTap: () {
              AudioService().playClickSound();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required Color color,
    required double width,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            // Flexible lets the text shrink if needed instead of overflowing
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getGradientColors() {
    if (_percentage >= 0.8) {
      return [const Color(0xFF11998E), const Color(0xFF38EF7D)];
    }
    if (_percentage >= 0.6) {
      return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    }
    return [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)];
  }
}
