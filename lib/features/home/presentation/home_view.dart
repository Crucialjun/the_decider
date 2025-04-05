import 'package:flutter/material.dart';
import 'package:the_decider/features/home/presentation/components/question_form.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
            QuestionForm(),
            const SizedBox(height: 20),
            Text(
              "Account Type: Free",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
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
}
