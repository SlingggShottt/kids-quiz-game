import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Attempt to start music immediately (works on mobile; deferred on web
    // until onUserInteraction() is called below).
    AudioService().playBackgroundMusic();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4776E6), Color(0xFF8E54E9), Color(0xFFFF6B6B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_bounceAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 220,
                    height: 220,
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
                    child: const Center(
                      child: Text('🎮', style: TextStyle(fontSize: 130)),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'Kids Quiz Game',
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          color: Colors.black26,
                          offset: Offset(3, 3),
                          blurRadius: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Learn About Fruits, Vegetables,\nVehicles & More!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),
                _buildMenuButton(
                  text: 'Play!',
                  icon: Icons.play_arrow,
                  color: const Color(0xFFFFE66D),
                  onTap: () async {
                    // First tap → unblocks web autoplay and starts music
                    await AudioService().onUserInteraction();
                    await AudioService().playClickSound();
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/categories');
                    }
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  text: 'Settings',
                  icon: Icons.settings,
                  color: const Color(0xFF48DBFB),
                  onTap: () async {
                    await AudioService().onUserInteraction();
                    await AudioService().playClickSound();
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/settings');
                    }
                  },
                ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
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
          children: [
            Icon(icon, color: Colors.white, size: 38),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
