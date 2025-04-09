import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:the_decider/features/home/presentation/components/question_form.dart';
import 'package:the_decider/features/home/presentation/components/show_question_and_answer.dart';
import 'package:the_decider/services/firebase_service/i_firebase_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String answer = "";
  TextEditingController questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decider'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Add your settings action here
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              // Add your info action here
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Decisions Left ##', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            QuestionForm(questionController: questionController),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _getAnswer();
                });
                Logger().i(answer);
              },
              child: const Text('Ask'),
            ),
            const SizedBox(height: 20),
            Text(
              "Account Type: Free",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: FutureBuilder(
                future: IFirebaseService().userAuthStatus().then((value) {
                  return value.fold(
                    (l) {
                      // user is not logged in
                      return null;
                    },
                    (r) {
                      // user is logged in
                      return r;
                    },
                  );
                }), // Add your FutureBuilder here to display user data
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text('User ID: ${snapshot.data?.uid}');
                  } else {
                    return const Text('No user data available');
                  }
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ShowQuestionAndAnswer(
                answer: answer,
                question: questionController.text,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your FAB action here
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _getAnswer() {
    var answerOptions = [
      "Yes",
      "No",
      "Maybe",
      "Definitely",
      "Absolutely not",
      "Ask again later",
    ];
    var randomIndex = Random().nextInt(answerOptions.length);
    answer = answerOptions[randomIndex];
  }
}
