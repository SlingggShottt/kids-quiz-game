import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/category.dart';
import '../models/question.dart';
import '../services/audio_service.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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
              Expanded(
                child: _buildCategoryGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              AudioService().playClickSound();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            ),
          ),
          const Expanded(
            child: Text(
              'Choose a Category',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF38EF7D),
      const Color(0xFF667EEA),
      const Color(0xFFFFE66D),
      const Color(0xFFFF922B),
      const Color(0xFFE84393),
    ];

    // Use LayoutBuilder to calculate available space
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card size to fit 2 columns and 3 rows without scrolling
        final availableWidth = constraints.maxWidth - 60;
        final availableHeight = constraints.maxHeight - 40;
        final cardWidth = (availableWidth - 30) / 2;
        final cardHeight = (availableHeight - 40) / 3;

        // Make cards square
        final cardSize = cardWidth < cardHeight ? cardWidth : cardHeight;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Row 1: Fruits and Vegetables
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryCard(context, categories[0], colors[0], cardSize),
                  _buildCategoryCard(context, categories[1], colors[1], cardSize),
                ],
              ),
              // Row 2: Vehicles and Animals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryCard(context, categories[2], colors[2], cardSize),
                  _buildCategoryCard(context, categories[3], colors[3], cardSize),
                ],
              ),
              // Row 3: Colors and Shapes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryCard(context, categories[4], colors[4], cardSize),
                  _buildCategoryCard(context, categories[5], colors[5], cardSize),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category, Color color, double size) {
    return GestureDetector(
      onTap: () {
        AudioService().playClickSound();
        // Shuffle and select 5 questions for the quiz
        final shuffledQuestions = List<Question>.from(category.questions)
          ..shuffle();
        final selectedQuestions = shuffledQuestions.take(5).toList();

        Navigator.pushNamed(
          context,
          '/quiz',
          arguments: {
            'category': category,
            'questions': selectedQuestions,
          },
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.icon,
              style: TextStyle(fontSize: size * 0.35),
            ),
            SizedBox(height: size * 0.05),
            Text(
              category.name,
              style: TextStyle(
                fontSize: size * 0.12,
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