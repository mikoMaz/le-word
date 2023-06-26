import 'package:animated_flip_widget/animated_flip_widget/flip_controler.dart';
import 'package:animated_flip_widget/animated_flip_widget/flip_widget.dart';
import 'package:flutter/material.dart';

class FlashcardPage extends StatefulWidget {
  final String setName;
  const FlashcardPage({super.key, required this.setName});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final _flipController = FlipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcard Page')),
      body: Center(
        child: AnimatedFlipWidget(
          front: const _FrontWidget(),
          back: const _BackWidget(),
          flipDirection: FlipDirection.horizontal,
          controller: _flipController,
          flipDuration: const Duration(milliseconds: 200),
        ),
      ),
    );
  }
}

class _FrontWidget extends StatelessWidget {
  const _FrontWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      color: Colors.grey,
      child: Center(
        child: Text(
          'defaultWord',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}

class _BackWidget extends StatelessWidget {
  const _BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      color: Colors.grey,
      child: Center(
        child: Text(
          'backWord',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
