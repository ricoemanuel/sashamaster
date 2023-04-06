import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
// ignore: non_constant_identifier_names
Future<dynamic> CreateUser(emailAddress, password) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    final uid = credential.user?.uid;
    return uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'weak';
    } else if (e.code == 'email-already-in-use') {
      return 'used';
    }
  }
}

// ignore: non_constant_identifier_names
Future<dynamic> SignIn(emailAddress, password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    final uid = credential.user?.uid;
    return uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return 'nonUser';
    } else if (e.code == 'wrong-password') {
      return 'wrongpass';
    }
  }
}

// ignore: non_constant_identifier_names
Future<dynamic> LogOut() async {
  await FirebaseAuth.instance.signOut();
  return 'signedout';
}

// ignore: non_constant_identifier_names
Future<dynamic> CreateUserFirestore(data) async {
  final user = await CreateUser(data["email"], data["password"]);
  if (user == "weak" || user == "used") {
    return user;
  } else if (user.lenght > 5) {
    db.collection("users").add(data);
  }
}
