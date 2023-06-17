import 'package:le_word_app/models/word.dart';

class WordSetModel {
  final String name;
  final String language;
  final List<WordModel> words;

  WordSetModel({required this.name, required this.language, required this.words});
}

// TODO: name of WordSetModel