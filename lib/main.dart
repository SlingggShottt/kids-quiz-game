import 'package:flutter/material.dart';
import 'models/category.dart';
import 'models/question.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/results_screen.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Quiz Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/categories': (context) => const CategoriesScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/results': (context) => const ResultsScreen(),
      },
    );
  }
}

class QuizScreenWrapper extends StatefulWidget {
  final Category category;

  const QuizScreenWrapper({super.key, required this.category});

  @override
  State<QuizScreenWrapper> createState() => _QuizScreenWrapperState();
}

class _QuizScreenWrapperState extends State<QuizScreenWrapper> {
  late List<Question> _questions;

  @override
  void initState() {
    super.initState();
    _questions = List.from(widget.category.questions)..shuffle();
    if (_questions.length > 5) {
      _questions = _questions.sublist(0, 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => QuizScreen(),
          settings: settings,
        );
      },
    );
  }
}
