import 'package:flutter/material.dart';
import 'package:le_word_app/data/hive_database.dart';
import 'package:le_word_app/models/set.dart';
import 'package:le_word_app/models/word.dart';

class SetListData extends ChangeNotifier {
  final db = HiveDatabase();

  List<WordSetModel> setList = [
    WordSetModel(
      name: 'Słówka z hiszpana',
      language: 'hiszpański',
      words: [
        WordModel(
          defaultWord: 'deweloper',
          backWord: 'desarrollar',
          confidenceLevel: 10,
        ),
        WordModel(
          defaultWord: 'komputer',
          backWord: 'computadora',
          confidenceLevel: 10,
        ),
      ],
    )
  ];

  void initializeWordList() {
    if (db.isPreviousDataExist()) {
      setList = db.readFromDatabase();
      // db.readFromDatabase();
    } else {
      db.saveToDatabase(setList);
    }
  }

  // get word list
  List<WordSetModel> getSetListData() {
    return setList;
  }

  void addSet(String setName, String language) {
    setList.add(WordSetModel(name: setName, language: language, words: []));

    notifyListeners();

    // save to db
    db.saveToDatabase(setList);
  }

  WordSetModel getSetFromGivenName(String setName) {
    WordSetModel specificSetWithGivenName =
        setList.firstWhere((set) => set.name == setName);
    return specificSetWithGivenName;
  }

  void addWord(String setName, String aDefaultWord, String aBackWord) {
    WordSetModel specificSetWithGivenName = getSetFromGivenName(setName);

    specificSetWithGivenName.words.add(
      WordModel(
        defaultWord: aDefaultWord,
        backWord: aBackWord,
        confidenceLevel: 10,
      ),
    );

    notifyListeners();

    // save to db
    db.saveToDatabase(setList);
  }

  // check-off wordTile (tam też notifyListeners)

  // delete Word

  WordModel getWordFromGivenName(String setName, String aWord) {
    WordSetModel setFromGivenName = getSetFromGivenName(setName);

    WordModel wordFromGivenName =
        setFromGivenName.words.firstWhere((word) => word.defaultWord == aWord);

    return wordFromGivenName;
  }

  int numberOfWordsInSet(String setName) {
    WordSetModel specificSetWithGivenName = getSetFromGivenName(setName);
    return specificSetWithGivenName.words.length;
  }

  void updateWord(String setName, int wordIndex, String defaultWord,
      String backWord, int confidenceLevel) {
    WordSetModel specificSetWithGivenName = getSetFromGivenName(setName);
    // TODO: use getWordFromGivenName; better to use wordIndex insted??? (word duplication problem)
    specificSetWithGivenName.words[wordIndex].confidenceLevel = confidenceLevel;
    // TOOD: update remaining parameters or delete them

    // notifyListeners();
    db.saveToDatabase(setList);
  }
}
