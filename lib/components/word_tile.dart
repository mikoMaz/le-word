import 'package:flutter/material.dart';

class WordTile extends StatelessWidget {
  final String setName;
  final String defaultWord;
  final String backWord;
  final int confidenceLevel;

  const WordTile(
      {super.key,
      required this.setName,
      required this.defaultWord,
      required this.backWord,
      required this.confidenceLevel});
    

  void goToTileLearn() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: ListTile(
          title: Text(defaultWord),
          subtitle: Row(
            children: [
              Chip(
                label: Text("$confidenceLevel"),
              )
            ],
          ),
          trailing: //Row(children: [
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () => goToTileLearn,
                  //goToSetByName(value.getSetListData()[index].name),
            ),
          // ]
          // )
          ),
    );
  }
}
