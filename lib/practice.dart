import 'package:flutter/material.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  int counter = 0;

  void _incrementCounter(){
    setState((){
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $counter'),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Text('Increment'),
        )
      ],
    );
  }
}

void main() => runApp(const MaterialApp(home: Scaffold(body: Practice())));
