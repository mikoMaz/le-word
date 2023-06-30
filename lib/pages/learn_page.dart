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
  bool _questionAnswerStatus = false;
  bool _correctAnswerStatus = false;

  final Color _defaultAnswerColor = Color.fromARGB(255, 82, 119, 173);
  final Color _correctAnswerColor = Colors.green;
  final Color _wrongAnswerColor = Colors.red;

  Color _questionOneColorState = Color.fromARGB(255, 82, 119, 173);
  Color _questionTwoColorState = Color.fromARGB(255, 82, 119, 173);
  Color _questionThreeColorState = Color.fromARGB(255, 82, 119, 173);

  @override
  Widget build(BuildContext context) {
    return Consumer<SetListData>(
      builder: (context, value, child) {
        List<double> confidenceLevelList = listOfConfidenceLevels(
            value.getSetFromGivenName(widget.setName).words);

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 17, 36, 53),
          body: ValueListenableBuilder(
            valueListenable: _counterNotifier,
            builder: (context, val, _) {
              if (value.getSetFromGivenName(widget.setName).words.length < 3) {
                // TODO: add Scaffold and empty set alert
                return Column(
                  children: [
                    /// Rounded app bar
                    Container(
                      // padding: EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.black),
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            height: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)))),
                                child: const Icon(
                                    Icons.arrow_circle_left_outlined)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 30),
                            child: Text(
                              widget.setName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        'Not enough data in set. Add ${3 - value.getSetFromGivenName(widget.setName).words.length} word${value.getSetFromGivenName(widget.setName).words.length == 2 ? '' : 's'} to start learning.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Noto Sans',
                        ),
                      ),
                    ),
                  ],
                );
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
                    /// Rounded app bar
                    Container(
                      // padding: EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.black),
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            height: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)))),
                                child: const Icon(
                                    Icons.arrow_circle_left_outlined)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 30),
                            child: Text(
                              widget.setName,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(25),
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 71, 59, 118),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              currentWordToLearn.defaultWord,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 70, right: 70, bottom: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!_questionAnswerStatus) {
                                      _questionOneColorState = checkAnswer(
                                          questions[0],
                                          value
                                              .getSetFromGivenName(
                                                  widget.setName)
                                              .words[questions[0]]
                                              .confidenceLevel,
                                          questions[questions[3]],
                                          questions[3],
                                          0);
                                      _questionNotifier.value++;
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !_correctAnswerStatus ||
                                            _questionOneColorState ==
                                                _correctAnswerColor
                                        ? _questionOneColorState
                                        : _defaultAnswerColor,
                                    minimumSize: const Size(0, 50),
                                  ),
                                  child: Text(
                                      style: const TextStyle(
                                        color: Colors.black,
                                        // fontSize: 30,
                                        fontFamily: 'Noto Sans',
                                      ),
                                      value
                                          .getSetFromGivenName(widget.setName)
                                          .words[questions[0]]
                                          .backWord),
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!_questionAnswerStatus) {
                                      _questionTwoColorState = checkAnswer(
                                          questions[1],
                                          value
                                              .getSetFromGivenName(
                                                  widget.setName)
                                              .words[questions[1]]
                                              .confidenceLevel,
                                          questions[questions[3]],
                                          questions[3],
                                          1);
                                      _questionNotifier.value++;
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !_correctAnswerStatus ||
                                            _questionTwoColorState ==
                                                _correctAnswerColor
                                        ? _questionTwoColorState
                                        : _defaultAnswerColor,
                                    minimumSize: const Size(0, 50),
                                  ),
                                  child: Text(
                                      style: const TextStyle(
                                        color: Colors.black,
                                        // fontSize: 30,
                                        fontFamily: 'Noto Sans',
                                      ),
                                      value
                                          .getSetFromGivenName(widget.setName)
                                          .words[questions[1]]
                                          .backWord),
                                ),
                              ),
                              Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!_questionAnswerStatus) {
                                      _questionThreeColorState = checkAnswer(
                                          questions[2],
                                          value
                                              .getSetFromGivenName(
                                                  widget.setName)
                                              .words[questions[2]]
                                              .confidenceLevel,
                                          questions[questions[3]],
                                          questions[3],
                                          2);
                                      _questionNotifier.value++;
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !_correctAnswerStatus ||
                                            _questionThreeColorState ==
                                                _correctAnswerColor
                                        ? _questionThreeColorState
                                        : _defaultAnswerColor,
                                    minimumSize: const Size(0, 50),
                                  ),
                                  child: Text(
                                      style: const TextStyle(
                                        color: Colors.black,
                                        // fontSize: 30,
                                        fontFamily: 'Noto Sans',
                                      ),
                                      value
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
                          ),
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
              _questionOneColorState = _defaultAnswerColor;
              _questionTwoColorState = _defaultAnswerColor;
              _questionThreeColorState = _defaultAnswerColor;
              _questionAnswerStatus = false;
              _correctAnswerStatus = false;
            },
            child: const Icon(Icons.navigate_next_rounded),
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
      _correctAnswerStatus = true;
      return _correctAnswerColor;
    } else {
      Provider.of<SetListData>(context, listen: false).updateWord(
          widget.setName,
          givenAbsoluteWordIndexAnswer,
          'NOT IMPORTANT',
          'NOT IMPORTANT',
          wrongAnswerConfidenceLevel(confidenceLevelOfAnswer));
      if (correctAnswer != 0) {
        _questionOneColorState = _wrongAnswerColor;
      }
      if (correctAnswer != 1) {
        _questionTwoColorState = _wrongAnswerColor;
      }
      if (correctAnswer != 2) {
        _questionThreeColorState = _wrongAnswerColor;
      }
      if (correctAnswer == 0) {
        _questionOneColorState = _correctAnswerColor;
      }
      if (correctAnswer == 1) {
        _questionTwoColorState = _correctAnswerColor;
      }
      if (correctAnswer == 2) {
        _questionThreeColorState = _correctAnswerColor;
      }
      _questionAnswerStatus = true;
      return _wrongAnswerColor;
    }
  }
}
