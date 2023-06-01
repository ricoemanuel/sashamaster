import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sashamaster/views/student.view.dart';

import '../controllers/firebase.controller.dart';

// ignore: camel_case_types
class StudentsList extends StatefulWidget {
  const StudentsList({Key? key}) : super(key: key);

  @override
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = getstudentsAccepted();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.docs
              .map<Map<String, dynamic>>((doc) =>
                  {'uid': doc.id, ...doc.data() as Map<dynamic, dynamic>})
              .toList();
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _stream = getstudents();
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    'Lista de Estudiantes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          var student = data[index];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text(data[index]['name']),
                                  ),
                                  body: UserInfoView(data: data[index])),
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage('lib/images/perfil.png'),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index]['name'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      data[index]['carreer'],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            child: Text('Error al obtener los datos'),
          );
        } else {
          return Container(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
