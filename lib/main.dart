import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sashamaster/controllers/firebase.controller.dart';
import 'package:sashamaster/views/signin.view.dart';
import 'package:sashamaster/views/start.view.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final currentUser = snapshot.data;
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
            ),
            home: currentUser == null ? const LoginPage() : const StartPage(),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            height: 40,
            width: 40,
            child: const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
