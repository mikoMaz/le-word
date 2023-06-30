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

  void goToTileLearn() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.grey[300],
        margin: const EdgeInsets.only(left: 17, top: 3, right: 17, bottom: 10),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 14),
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      defaultWord,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 14),
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      backWord,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      "Confidence level: ${confidenceLevel.toString()}",
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
