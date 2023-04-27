import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:core';

FirebaseFirestore db = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();

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
  return true;
}

// ignore: non_constant_identifier_names
Future<dynamic> CreateUserFirestore(data) async {
  final user = await CreateUser(data["email"], data["password"]);
  if (user == 1 || user == 2) {
    return user;
    // ignore: unrelated_type_equality_checks
  } else {
    data.remove("password");
    data.remove("email");
    return await db.collection("users").doc(user).set(data);
  }
}

// ignore: non_constant_identifier_names
Future<dynamic> GetUser(uid) async {
  var user = db.collection("users").doc(uid).get();
  return user;
}

// ignore: non_constant_identifier_names
Stream<QuerySnapshot> getNotAcceptedUsers() {
  return db.collection("users").where("state", isEqualTo: "1").snapshots();
}


// ignore: non_constant_identifier_names
Future<Map<String, dynamic>> CurrentUser() async {
  final user = FirebaseAuth.instance.currentUser;
  var data = await GetUser(user?.uid);
  return data.data();
}

Future<String> uploadFile(File file) async {
  try {
    final fileName = basename(file.path);
    DateTime now = DateTime.now();
    var time =
        DateTime(now.year, now.month, now.day, now.second, now.microsecond)
            .toString();
    final destination = 'images/$fileName-$time';
    final ref = storageRef.child(destination);
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    return url;
  } catch (e) {
    return e.toString();
  }
}

// ignore: non_constant_identifier_names
Future<dynamic> EditUser(data) async {
  try {
    var user = data['uid'];
    data.remove("uid");
    return await db.collection("users").doc(user).set(data);
  } on Exception catch (e) {
    print(e);
  }
}
