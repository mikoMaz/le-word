import 'package:flutter/material.dart';
import 'package:le_word_app/models/set.dart';
import 'package:le_word_app/models/word.dart';

class SetListData extends ChangeNotifier {
  List<WordSetModel> setList = [
    WordSetModel(
      name: 'Słówka z hiszpana',
      language: 'hiszpański',
      words: [
        WordModel(
          defaultWord: 'deweloper',
          backWord: 'desarrollar',
          confidenceLevel: 0,
        ),
        WordModel(
          defaultWord: 'komputer',
          backWord: 'computadora',
          confidenceLevel: 0,
        ),
      ],
    )
  ];

  // get word list
  List<WordSetModel> getSetListData() {
    return setList;
  }

  void addSet(String setName, String language) {
    setList.add(WordSetModel(name: setName, language: language, words: []));

    notifyListeners();
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
        confidenceLevel: 0,
      ),
    );

    notifyListeners();
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
}
