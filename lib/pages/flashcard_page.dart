import 'package:animated_flip_widget/animated_flip_widget/flip_controler.dart';
import 'package:animated_flip_widget/animated_flip_widget/flip_widget.dart';
import 'package:flutter/material.dart';
import 'package:le_word_app/data/set_list_data.dart';
import 'package:le_word_app/models/word.dart';
import 'package:provider/provider.dart';

class FlashcardPage extends StatefulWidget {
  final String setName;
  const FlashcardPage({super.key, required this.setName});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  int _counter = 0;
  final _flipController = FlipController();
  int _currentWord = 0;
  // TODO: add default side (defaultWord or backWord)

  @override
  Widget build(BuildContext context) {
    return Consumer<SetListData>(
      builder: (context, value, child) {
        canBeSkipped(value.getSetFromGivenName(widget.setName).words)
            ? _currentWord
            : _currentWord;
        return Scaffold(
          appBar: AppBar(title: const Text('Flashcard Page')),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 100),
                  child: AnimatedFlipWidget(
                    front: _FrontWidget(
                        defaultWord: value
                            .getSetFromGivenName(widget.setName)
                            .words[_currentWord]
                            .defaultWord),
                    back: _BackWidget(
                        backWord: value
                            .getSetFromGivenName(widget.setName)
                            .words[_currentWord]
                            .backWord),
                    flipDirection: FlipDirection.horizontal,
                    controller: _flipController,
                    flipDuration: const Duration(milliseconds: 200),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 50, right: 50, bottom: 130),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // not important? (underline alert)
                      width: 200,
                      height: 50,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            previousWord(_currentWord);
                            setState(
                              () {
                                _counter++;
                              },
                            );
                          },
                          child: const Text(
                            'Previous word',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 50,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            nextWord(_currentWord);
                            setState(
                              () {
                                _counter++;
                              },
                            );
                          },
                          child: const Text(
                            'Next word',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    )
                    // TODO: add word counter
                    // TODO: chnage to defaultWord after skip
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void nextWord(int currentWord) {
    _currentWord++;
  }

  void previousWord(int currentWord) {
    _currentWord--;
  }

  bool canBeSkipped(List<WordModel> set) {
    if (_currentWord >= set.length) {
      _currentWord--;
      return false;
    }
    if (_currentWord < 0) {
      _currentWord++;
      return false;
    }
    return true;
  }
}

class _FrontWidget extends StatelessWidget {
  final String defaultWord;
  const _FrontWidget({Key? key, required this.defaultWord}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      color: Colors.grey[100],
      child: Center(
        child: Text(
          defaultWord,
          style: const TextStyle(
            fontSize: 32,
            fontFamily: 'Noto Sans',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _BackWidget extends StatelessWidget {
  final String backWord;
  const _BackWidget({Key? key, required this.backWord}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      color: Colors.grey[100],
      child: Center(
        child: Text(
          backWord,
          style: const TextStyle(
            fontSize: 32,
            fontFamily: 'Noto Sans',
          ),
        ),
      ),
    );
  }
}
