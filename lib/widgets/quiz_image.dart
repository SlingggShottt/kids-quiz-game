import 'package:flutter/material.dart';

class QuizImage extends StatefulWidget {
  final String imagePath;
  final String category;
  /// Rendered width and height. Passed in from the parent so the
  /// image scales correctly on every screen size.
  final double size;

  const QuizImage({
    super.key,
    required this.imagePath,
    required this.category,
    this.size = 160,
  });

  @override
  State<QuizImage> createState() => _QuizImageState();
}

class _QuizImageState extends State<QuizImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.size * 0.15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.size * 0.15),
          child: Image.asset(
            // Path pattern: assets/images/<category>/<imageName>.png
            // e.g. assets/images/animals/lion.png
            'assets/images/${widget.category}/${widget.imagePath}.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              debugPrint(
                  'QuizImage: image not found – '
                  'assets/images/${widget.category}/${widget.imagePath}.png');
              return _buildPlaceholder();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final color = _getCategoryColor();
    return Container(
      color: color.withOpacity(0.15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getCategoryIcon(),
                size: widget.size * 0.45, color: color),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.imagePath,
                style: TextStyle(
                  fontSize: (widget.size * 0.1).clamp(10.0, 16.0),
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (widget.category.toLowerCase()) {
      case 'fruits':      return Colors.orange;
      case 'vegetables':  return Colors.green;
      case 'vehicles':    return Colors.blue;
      case 'animals':     return Colors.brown;
      case 'colors':      return Colors.purple;
      case 'shapes':      return Colors.pink;
      default:            return Colors.blueGrey;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.category.toLowerCase()) {
      case 'fruits':      return Icons.apple;
      case 'vegetables':  return Icons.eco;
      case 'vehicles':    return Icons.directions_car;
      case 'animals':     return Icons.pets;
      case 'colors':      return Icons.palette;
      case 'shapes':      return Icons.star;
      default:            return Icons.image_not_supported;
    }
  }
}
