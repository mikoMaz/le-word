import 'package:flutter/material.dart';
import 'package:le_word_app/data/set_list_data.dart';
import 'package:le_word_app/pages/flashcard_page.dart';
import 'package:le_word_app/pages/learn_page.dart';
import 'package:le_word_app/pages/set_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SetListData>(context, listen: false).initializeWordList();
  }

  final setNewNameTextController = TextEditingController();

  void createNewSet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create new set'),
        content: TextField(
          controller: setNewNameTextController,
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text('save'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text('cancel'),
          ),
        ],
      ),
    );
  }

  void goToSetByName(String setName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetPage(
          setName: setName,
        ),
      ),
    );
  }

  void goToLearnByName(String setName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearnPage(setName: setName),
      ),
    );
  }

  void goToFlashcardPageBySetName(String setName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardPage(setName: setName),
      ),
    );
  }

  void save() {
    String newNameTextController = setNewNameTextController.text;

    Provider.of<SetListData>(context, listen: false)
        .addSet(newNameTextController, 'espanol');

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    setNewNameTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SetListData>(
      builder: (context, value, child) => (Scaffold(
        appBar: AppBar(
          title: const Text('LeWord'),
          backgroundColor: Colors.black,
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.white,
          hoverColor: Colors.grey[600],
          splashColor: Colors.grey[500],
          backgroundColor: Colors.grey[500],
          onPressed: createNewSet,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getSetListData().length,
          itemBuilder: (context, index) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.grey[300],
            margin: const EdgeInsets.only(left: 17, top: 17, right: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15.0),
                  height: 60,
                  child: Center(
                    child: Text(
                      value.getSetListData()[index].name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Noto Sans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  child: Row(
                    children: [
                      Container(
                        height: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              goToSetByName(value.getSetListData()[index].name),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[500],
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                          child: const Icon(Icons.list_rounded),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => goToFlashcardPageBySetName(
                              value.getSetListData()[index].name),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[500],
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero),
                            ),
                          ),
                          child: const Icon(Icons.layers),
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => goToLearnByName(
                              value.getSetListData()[index].name),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[500],
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          child: const Icon(Icons.library_books),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
