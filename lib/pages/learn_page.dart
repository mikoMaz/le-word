import 'dart:js_interop';

import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:le_word_app/data/set_list_data.dart';
import 'package:le_word_app/models/word.dart';
import 'package:provider/provider.dart';

class LearnPage extends StatefulWidget {
  final String setName;
  const LearnPage({super.key, required this.setName});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

List<int> randomOrder(int listLength) {
  List<int> randomizedList = [];

  for (int i = 0; i < listLength; i++) {
    randomizedList.add(i);
  }

  randomizedList.shuffle();
  return randomizedList;
}

List<double> listOfConfidenceLevels(List<WordModel> set) {
  List<double> listOfConfidenceLevels = [];
  for (int i = 0; i < set.length; i++) {
    listOfConfidenceLevels.add(100 - set[i].confidenceLevel.toDouble());
  }
  return listOfConfidenceLevels;
}

int returnRandomWordIndexByConfidenceLevel(
    List<double> confidenceLevelList, List<WordModel> set, int lastWordIndex) {
  // TODO: better to move to other method?
  List<int> indexList = [];
  for (int i = 0; i < confidenceLevelList.length; i++) {
    indexList.add(i);
  }

  int indexOfWord = randomChoice(indexList, confidenceLevelList);

  if (set.length >= 2) {
    while (lastWordIndex == indexOfWord) {
      indexOfWord = randomChoice(indexList, confidenceLevelList);
    }
  }

  return indexOfWord;
}

WordModel returnCurrentWordToLearn(
    List<WordModel> set,
    List<double> confidenceLevelList,
    int randomWordIndexByConfidenceLevel,
    int lastWordIndex) {
  WordModel nextWord = set[randomWordIndexByConfidenceLevel];
  return nextWord;
}

int goodAnswer(int confidenceLevel) {
  return confidenceLevel + ((100 - confidenceLevel) / 2).floor();
}

int badAnswer(int confidenceLevel) {
  return (confidenceLevel / 2).ceil();
}

class _LearnPageState extends State<LearnPage> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  // _changeLastWordIndex(int lastWordIndex) {
  //   _lastWordIndex = lastWordIndex;
  //   print('LWI: ' + _lastWordIndex.toString());
  //   setState(() {});
  // }

  final _counterNotifier = ValueNotifier<int>(0);
  int _lastWordIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<SetListData>(
      builder: (context, value, child) {
        // List<int> rarandomOrderList =
        //     randomOrder(value.numberOfWordsInSet(widget.setName));
        List<double> confidenceLevelList = listOfConfidenceLevels(
            value.getSetFromGivenName(widget.setName).words);

        return Scaffold(
          body: ValueListenableBuilder(
            valueListenable: _counterNotifier,
            builder: (context, val, _) {
              if (value.getSetFromGivenName(widget.setName).words.isEmpty) {
                // add Scaffold and empty set alert
                return Text('No data in set. Add words to start learning.');
              } else {
                int randomWordIndexByConfidenceLevel =
                    returnRandomWordIndexByConfidenceLevel(
                        confidenceLevelList,
                        value.getSetFromGivenName(widget.setName).words,
                        _lastWordIndex);
                WordModel currentWordToLearn = returnCurrentWordToLearn(
                    value.getSetFromGivenName(widget.setName).words,
                    confidenceLevelList,
                    randomWordIndexByConfidenceLevel,
                    _lastWordIndex);
                _lastWordIndex = randomWordIndexByConfidenceLevel;

                // () => _changeLastWordIndex(
                //     randomWordIndexByConfidenceLevel, _lastWordIndex);

                return Text('Word: ${currentWordToLearn.defaultWord}');
                // return Text('Word: ${value.getSetFromGivenName(widget.setName).words[val].defaultWord}');
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _counterNotifier.value++;
              // _changeLastWordIndex(
              //     _randomWordIndexByConfidenceLevel);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _counterNotifier.dispose();
    super.dispose();
  }
}
