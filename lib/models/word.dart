class WordModel {
  final String defaultWord;
  final String backWord;
  int confidenceLevel;


  WordModel({
    required this.defaultWord,
    required this.backWord,
    required this.confidenceLevel,
  });
}