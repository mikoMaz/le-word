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
        // appBar: AppBar(
        //   title: Text(widget.setName), // from where is widget??
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWordPair,
          child: const Icon(Icons.add),
        ),
        body: Column(
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
                        child: const Icon(Icons.arrow_circle_left_outlined)),
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
              // Expanded added for the ListView.builder, when in Column
              child: ListView.builder(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
