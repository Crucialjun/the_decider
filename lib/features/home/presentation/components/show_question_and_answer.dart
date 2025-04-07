import 'package:flutter/material.dart';
import 'package:the_decider/extensions/string_extension.dart';

class ShowQuestionAndAnswer extends StatelessWidget {
  const ShowQuestionAndAnswer({super.key, required this.answer});

  final String answer; // Placeholder for the answer

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Should I...?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Answer: ${(answer.isNotEmpty ? answer : "No answer yet").capitalize()}",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ],
    );
  }
}
