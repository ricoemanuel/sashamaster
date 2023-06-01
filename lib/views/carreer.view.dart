import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sashamaster/controllers/firebase.controller.dart';

class carreer extends StatelessWidget {
  final List<dynamic> data;
  final int index;

  const carreer({Key? key, required this.data, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16), // Ajusta el valor de padding según tus necesidades
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Créditos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${data[index]['points']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Materias:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: data[index]['subjects'].length,
                itemBuilder: (context, i) {
                  final subject = data[index]['subjects'][i]['code'];
                  final term = data[index]['subjects'][i]['term'];
                  return FutureBuilder(
                    future: db.collection('subjects').doc(subject).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final doc = snapshot.data as DocumentSnapshot;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10), // Borde circular
                            border: Border.all(
                                color: Colors.grey), // Borde de color gris
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc['name'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                    height:
                                        8), // Espaciado adicional de 8 puntos
                                Text(
                                  'Semestre: $term',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ), // Espacio vertical entre los elementos
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: data[index]['state'] == "1"
                ? ElevatedButton(
                    onPressed: () {
                      data[index]['state'] = "2";
                      final Map<String, dynamic> mapData =
                          Map<String, dynamic>.from(data[index]);
                      EditUser(mapData);
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 50)),
                    ),
                    child:
                        const Text('Aceptar', style: TextStyle(fontSize: 18)),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
