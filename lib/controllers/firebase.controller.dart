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
      return 1;
    } else if (e.code == 'email-already-in-use') {
      return 2;
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
      return 1;
    } else if (e.code == 'wrong-password') {
      return 2;
    }
  }
}

// ignore: non_constant_identifier_names
Future<dynamic> LogOut() async {
  await FirebaseAuth.instance.signOut();
  return 1;
}

// ignore: non_constant_identifier_names
Future<dynamic> CreateUserFirestore(data) async {
  final user = await CreateUser(data["email"], data["password"]);
  if (user == 1 || user == 2) {
    return user;
    // ignore: unrelated_type_equality_checks
  } else if (user.runtimeType == "String") {
    data.remove("password");
    data.remove("email");
    await db.collection("users").doc(user).set(data);
    return user;
  }
}

// ignore: non_constant_identifier_names
Future<dynamic> GetUser(uid) async {
  var user = db.collection("users").doc(uid).get();
  return user;
}

// ignore: non_constant_identifier_names
Future<Map<String, dynamic>> CurrentUser() async {
  final user = FirebaseAuth.instance.currentUser;
  var data = await GetUser(user?.uid);
  return data.data();
}
