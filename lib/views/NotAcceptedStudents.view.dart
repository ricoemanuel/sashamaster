import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sashamaster/views/student.view.dart';

import '../controllers/firebase.controller.dart';

// ignore: camel_case_types
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = getNotAcceptedUsers();
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
                _stream = getNotAcceptedUsers();
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    'Usuarios sin aceptar',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text(data[index]['name']),
                                  ),
                                  body: CardWidget(data: data, index: index)),
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                  NetworkImage(data[index]['photo']),
                                  radius: 30,
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

