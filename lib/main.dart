import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:the_decider/features/home/presentation/home_view.dart';
import 'package:the_decider/firebase_options.dart';
import 'package:the_decider/services/firebase_service/firebase_service.dart';
import 'package:the_decider/services/firebase_service/i_firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _getOrCreateUser();
  runApp(const MyApp());
}

void _getOrCreateUser() {
  IFirebaseService firebaseService = IFirebaseService();
  firebaseService.userAuthStatus().then((value) {
    value.fold((l) {
      // user is not logged in
      Logger().e('User is not logged in: ${l.message}');
      firebaseService.loginAnonymously().then((r) {
        r.fold((l) {
          // user is not logged in
          Logger().e('User is not logged in: ${l.message}');
        }, (r) {
          // user is logged in
          Logger().e('User is logged in: ${r?.uid}');
        });
      });
    }, (r) {
      // user is logged in
      Logger().e('User is logged in: ${r.uid}');
        });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decider',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const HomeView(),
    );
  }
}
