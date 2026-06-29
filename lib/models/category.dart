import 'question.dart';

class Category {
  final String name;
  final String icon;
  final List<Question> questions;
  final String? gameRoute;

  Category({
    required this.name,
    required this.icon,
    this.questions = const [],
    this.gameRoute,
  });
}
