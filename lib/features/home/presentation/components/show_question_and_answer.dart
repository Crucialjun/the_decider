import 'package:flutter/material.dart';
import 'package:the_decider/extensions/string_extension.dart';

class ShowQuestionAndAnswer extends StatelessWidget {
  const ShowQuestionAndAnswer({super.key, required this.answer, required this.question});

  final String answer; // Placeholder for the answer
  final String question;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(
          "Should I...${question}?",
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
