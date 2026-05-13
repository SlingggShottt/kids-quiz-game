import 'question.dart';

class Category {
  final String name;
  final String icon;
  final List<Question> questions;

  Category({
    required this.name,
    required this.icon,
    required this.questions,
  });
}
