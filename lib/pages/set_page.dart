import 'package:flutter/material.dart';
import 'package:le_word_app/components/word_tile.dart';
import 'package:le_word_app/data/set_list_data.dart';
import 'package:provider/provider.dart';

class SetPage extends StatefulWidget {
  final String setName;
  const SetPage({super.key, required this.setName});

  @override
  State<SetPage> createState() => _SetPageState();
}

class _SetPageState extends State<SetPage> {
  final defaultWordController = TextEditingController();
  final backWordController = TextEditingController();

  void createNewWordPair() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add new word parir'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: defaultWordController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'word',
              ),
            ),
            TextField(
              controller: backWordController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'translation',
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text('save'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text('cancel'),
          ),
        ],
      ),
    );
  }

  void save() {
    String newDefaultWord = defaultWordController.text;
    String newBackWord = backWordController.text;

    Provider.of<SetListData>(context, listen: false)
        .addWord(widget.setName, newDefaultWord, newBackWord);

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    defaultWordController.clear();
    backWordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SetListData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.setName), // from where is widget??
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWordPair,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.numberOfWordsInSet(widget.setName),
            itemBuilder: (context, index) => WordTile(
                  setName: widget.setName,
                  defaultWord: value
                      .getSetFromGivenName(widget.setName)
                      .words[index]
                      .defaultWord,
                  backWord: value
                      .getSetFromGivenName(widget.setName)
                      .words[index]
                      .backWord,
                  confidenceLevel: value
                      .getSetFromGivenName(widget.setName)
                      .words[index]
                      .confidenceLevel,
                )),
      ),
    );
  }
}
