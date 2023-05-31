import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sashamaster/views/student.view.dart';

import '../controllers/firebase.controller.dart';
import 'carreer.view.dart';
import 'formCarreer.view.dart';

// ignore: camel_case_types
class carreers extends StatefulWidget {
  const carreers({Key? key}) : super(key: key);

  @override
  _carreersState createState() => _carreersState();
}

class _carreersState extends State<carreers> {
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = getCarreers();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.docs
              .map<Map<String, dynamic>>((doc) =>
                  {'id': doc.id, ...doc.data() as Map<dynamic, dynamic>})
              .toList();
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _stream = getCarreers();
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Carreras',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text('Nueva carrera'),
                                  ),
                                  body: CarreerForm(),
                                ),
                              ));
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
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
                                  body: carreer(data: data, index: index)),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Borde circular
                            side: BorderSide(
                                color: Color.fromARGB(255, 200, 189, 189)!,
                                width: 1), // Borde más oscuro
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight
                                              .bold), // Texto más grande y en negrita
                                    ),
                                    Text(
                                      data[index]['points'],
                                      style: const TextStyle(
                                          fontSize: 14), // Texto más grande
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
