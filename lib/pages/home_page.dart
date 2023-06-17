import 'package:flutter/material.dart';
import 'package:le_word_app/data/set_list_data.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void save() {
    String newNameTextController = setNewNameTextController.text;

    Provider.of<SetListData>(context, listen: false).addSet(newNameTextController, 'espanol');

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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewSet,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getSetListData().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getSetListData()[index].name),
          ),
        ),
      )),
    );
  }
}
