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
        title: Text('Create new set'),
        content: TextField(
          controller: setNewNameTextController,
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
          onPressed: createNewSet,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getSetListData().length,
          itemBuilder: (context,
                  index) => /* ListTile(
            title: Text(value.getSetListData()[index].name),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () => goToSetByName(value.getSetListData()[index].name),
            ),
          ), */
              Card(
                color: Color.fromARGB(255, 90,100,134),
            margin: EdgeInsets.all(14),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(value.getSetListData()[index].name),
                  ElevatedButton.icon(
                    onPressed: () =>
                        goToSetByName(value.getSetListData()[index].name),
                    icon: Icon(Icons.list_rounded),
                    label: Text(''),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => goToFlashcardPageBySetName(
                        value.getSetListData()[index].name),
                    icon: Icon(Icons.layers),
                    label: Text(''),
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        goToLearnByName(value.getSetListData()[index].name),
                    icon: Icon(Icons.library_books),
                    label: Text(''),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
