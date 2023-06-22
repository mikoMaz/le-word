import 'package:flutter/material.dart';
import 'package:le_word_app/data/set_list_data.dart';
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

class _LearnPageState extends State<LearnPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   List<int> randomOrderList = randomOrder(widget.setName.length);
  // }

  @override
  Widget build(BuildContext context) {
    List<int> rndList = randomOrder(widget.setName.length);
    // Consumer<SetListData>(
    //   builder:(context, value, child) => Placeholder(),
    // );
    return Consumer<SetListData>(
      builder: (context, value, child) {
        // List<int> rarandomOrderList = randomOrder(value.getSetFromGivenName(widget.setName).words.length);
        List<int> rarandomOrderList =
            randomOrder(value.numberOfWordsInSet(widget.setName));
        print(rarandomOrderList);
        print(value.getSetFromGivenName(widget.setName).words);
        return Scaffold(
        body: ListView.builder(
          itemCount: rarandomOrderList.length,
          itemBuilder: (context, index) => Placeholder(),
        ));
      },
    );
  }
}
