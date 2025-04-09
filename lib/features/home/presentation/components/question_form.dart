import 'package:flutter/material.dart';

class QuestionForm extends StatelessWidget {
  const QuestionForm({super.key, required this.questionController});

  final TextEditingController questionController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text("Should I...", style: Theme.of(context).textTheme.headlineLarge),

          const SizedBox(height: 10),
          TextField(
            controller: questionController,
            decoration: InputDecoration(
              helperText: 'Enter your question',
              labelText: 'Enter a question',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
