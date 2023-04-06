import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sasha Master',
      home: Scaffold(appBar:AppBar(
        title: const Text("Sasha Master"),
      ),
      body: const Center(
        child: Text("Hola mundo"),
      ),),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
    );
  }
}
