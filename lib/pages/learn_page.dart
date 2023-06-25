import 'dart:math';
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

int correctAnswerConfidenceLevel(int confidenceLevel) {
  return confidenceLevel + ((100 - confidenceLevel) / 2).floor();
}

int wrongAnswerConfidenceLevel(int confidenceLevel) {
  return (confidenceLevel / 2).ceil();
}

List<int> returnQuestions(int setLength, int lastWordIndex) {
  // TODO: show wrong answers according to confidenceLevel
  // TODO: don't show answers with >= 75 confidence level or any other
  List<int> indexesOfRandomWords = [-1, -1, -1];
  int indexOfCorrectAnswer = Random().nextInt(3);
  indexesOfRandomWords[indexOfCorrectAnswer] = lastWordIndex;

  int randomWordIndex = -1;
  int indexForRandomWord = Random().nextInt(3);

  for (int i = 0; i < 2; i++) {
    while (randomWordIndex == -1 ||
        indexesOfRandomWords[indexForRandomWord] == randomWordIndex ||
        indexesOfRandomWords[indexOfCorrectAnswer] == randomWordIndex) {
      randomWordIndex = Random().nextInt(setLength);
    }

    while (indexesOfRandomWords[indexForRandomWord] != -1) {
      indexForRandomWord = Random().nextInt(3);
    }

    indexesOfRandomWords[indexForRandomWord] = randomWordIndex;
  }

  indexesOfRandomWords.add(indexOfCorrectAnswer);
  return indexesOfRandomWords;
}

class _LearnPageState extends State<LearnPage> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  final _counterNotifier = ValueNotifier<int>(0);
  final _questionNotifier = ValueNotifier<int>(0);
  int _lastWordIndex = -1;
  Color _questionOneColorState = Colors.white70;
  Color _questionTwoColorState = Colors.white70;
  Color _questionThreeColorState = Colors.white70;

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
              if (value.getSetFromGivenName(widget.setName).words.length < 3) {
                // add Scaffold and empty set alert
                return Text(
                    'Not enough data in set. Add ${3 - value.getSetFromGivenName(widget.setName).words.length} word${value.getSetFromGivenName(widget.setName).words.length == 2 ? '' : 's'} to start learning.');
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

                List<int> questions = returnQuestions(
                    value.getSetFromGivenName(widget.setName).words.length,
                    _lastWordIndex);

                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(25),
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              currentWordToLearn.defaultWord,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Noto Sans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _questionNotifier,
                      builder: (questionContext, questionValue, _) {
                        return Column(
                          children: [
                            Card(
                              child: ElevatedButton(
                                onPressed: () {
                                  _questionOneColorState = checkAnswer(
                                      questions[0],
                                      value
                                          .getSetFromGivenName(widget.setName)
                                          .words[questions[0]]
                                          .confidenceLevel,
                                      questions[questions[3]],
                                      questions[3],
                                      0);
                                  _questionNotifier.value++;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _questionOneColorState,
                                ),
                                child: Text(value
                                    .getSetFromGivenName(widget.setName)
                                    .words[questions[0]]
                                    .backWord),
                              ),
                            ),
                            Card(
                              child: ElevatedButton(
                                onPressed: () {
                                  _questionTwoColorState = checkAnswer(
                                      questions[1],
                                      value
                                          .getSetFromGivenName(widget.setName)
                                          .words[questions[1]]
                                          .confidenceLevel,
                                      questions[questions[3]],
                                      questions[3],
                                      1);
                                  _questionNotifier.value++;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _questionTwoColorState,
                                ),
                                child: Text(value
                                    .getSetFromGivenName(widget.setName)
                                    .words[questions[1]]
                                    .backWord),
                              ),
                            ),
                            Card(
                              child: ElevatedButton(
                                onPressed: () {
                                  _questionThreeColorState = checkAnswer(
                                      questions[2],
                                      value
                                          .getSetFromGivenName(widget.setName)
                                          .words[questions[2]]
                                          .confidenceLevel,
                                      questions[questions[3]],
                                      questions[3],
                                      2);
                                  _questionNotifier.value++;
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _questionThreeColorState,
                                ),
                                child: Text(value
                                    .getSetFromGivenName(widget.setName)
                                    .words[questions[2]]
                                    .backWord),
                              ),
                            ),
                            Text(
                              value
                                  .getSetFromGivenName(widget.setName)
                                  .words[questions[questions[3]]]
                                  .backWord,
                            ),
                          ],
                        );
                      },
                    )
                  ],
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _counterNotifier.value++;
              _questionOneColorState = Colors.white70;
              _questionTwoColorState = Colors.white70;
              _questionThreeColorState = Colors.white70;
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
    _questionNotifier.dispose();
    super.dispose();
  }

  Color checkAnswer(
      int givenAbsoluteWordIndexAnswer,
      int confidenceLevelOfAnswer,
      int correctAbsoluteWordIndex,
      int correctAnswer,
      int givenAnswer) {
    // TODO: block giving answers after response
    // TODO: delete unnecessary duplication (if)
    // TODO: delete unnecessary duplication (if + return)
    // TODO: add 'Don't know answer'; calculate every word as wrongAnswerConfidenceLevel
    if (givenAnswer == correctAnswer) {
      Provider.of<SetListData>(context, listen: false).updateWord(
          widget.setName,
          correctAbsoluteWordIndex,
          'NOT IMPORTANT',
          'NOT IMPORTANT',
          correctAnswerConfidenceLevel(confidenceLevelOfAnswer));
      return Colors.green;
    } else {
      Provider.of<SetListData>(context, listen: false).updateWord(
          widget.setName,
          givenAbsoluteWordIndexAnswer,
          'NOT IMPORTANT',
          'NOT IMPORTANT',
          wrongAnswerConfidenceLevel(confidenceLevelOfAnswer));
      if (correctAnswer != 0) {
        _questionOneColorState = Colors.red;
      }
      if (correctAnswer != 1) {
        _questionTwoColorState = Colors.red;
      }
      if (correctAnswer != 2) {
        _questionThreeColorState = Colors.red;
      }
      if (correctAnswer == 0) {
        _questionOneColorState = Colors.green;
      }
      if (correctAnswer == 1) {
        _questionTwoColorState = Colors.green;
      }
      if (correctAnswer == 2) {
        _questionThreeColorState = Colors.green;
      }
      return Colors.red;
    }
  }
}
