import 'package:hive_flutter/hive_flutter.dart';
import 'package:le_word_app/datetime/date_time.dart';
import 'package:le_word_app/models/set.dart';
import 'package:le_word_app/models/word.dart';

class HiveDatabase {
  // reference hive box
  final _myBox = Hive.box("word_set_database");

  // checks if data is already stored
  bool isPreviousDataExist() {
    if (_myBox.isEmpty) {
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      return true;
    }
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<WordSetModel> sets) {
    final setList = convertObjectToSetList(sets);
    final wordList = convertObjectToWordModelList(sets);

    // save to hive
    _myBox.put("SETS", setList);
    _myBox.put("WORDS", wordList);
  }

  // read data
  List<WordSetModel> readFromDatabase() {
    List<WordSetModel> mySavedWordSets = [];

    final setNames = _myBox.get("SETS");
    final wordPairDetails = _myBox.get("WORDS");

    for (int i = 0; i < setNames.length; i++) {
      List<WordModel> wordsInEachSet = [];

      for (int j = 0; j < wordPairDetails[i].length; j++) {
        wordsInEachSet.add(
          WordModel(defaultWord: wordPairDetails[i][j][0], backWord: wordPairDetails[i][j][1], confidenceLevel: int.parse(wordPairDetails[i][j][2]))
        );
      }
      // create individual set
      WordSetModel wordSetModel = WordSetModel(name: setNames[i], language: 'es', words: wordsInEachSet);

      // add individual workout to overall list
      mySavedWordSets.add(wordSetModel);
    }
    return mySavedWordSets;
  }
  
}

List<String> convertObjectToSetList(List<WordSetModel> sets) {
  List<String> wordSetList = [];

  for (int i = 0; i < sets.length; i++) {
    wordSetList.add(sets[i].name);
  }

  return wordSetList;
}

List<List<List<String>>> convertObjectToWordModelList(List<WordSetModel> sets) {
  List<List<List<String>>> wordList = [
    /*
  [
    set1
    [ [defaultWord, backWord, confidenceLevel], [...] ],

    set2
    [ [...],  [...] ]
  ]
*/
  ];

  for (int i = 0; i < sets.length; i++) {
    List<WordModel> wordsInSet = sets[i].words;
    List<List<String>> individualWordSet = [
      /*
        set_i
        [ [defaultWord, backWord, confidenceLevel], [...] ]
      */
    ];

    for (int j = 0; j < wordsInSet.length; j++) {
      List<String> individualWordPair = [
        /*
          [defaultWord, backWord, confidenceLevel]
        */
      ];

      individualWordPair.addAll([
        wordsInSet[j].defaultWord,
        wordsInSet[j].backWord,
        wordsInSet[j].confidenceLevel.toString(),
      ]);
      individualWordSet.add(individualWordPair);
    }
    wordList.add(individualWordSet);
  }

  return wordList;
}
