import 'package:flutter/material.dart';

class QuestionForm extends StatelessWidget {
  const QuestionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text("Should I...", style: Theme.of(context).textTheme.headlineLarge),

          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter a question',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle the button press
            },
            child: const Text('Ask'),
          ),
        ],
      ),
    );
  }
}
