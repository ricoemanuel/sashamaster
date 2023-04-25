import 'package:flutter/material.dart';

import '../controllers/firebase.controller.dart';

// ignore: camel_case_types
class term extends StatelessWidget {
  const term({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: CurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final terms = data["term"];
          final List<Widget> items = List.generate(
            terms,
            (index) => Material(
              elevation: 4,
              child: SizedBox(
  width: 300,
  height: 100,
  child: ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    title: Text(
      'Semestre ${index + 1}',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 24, // Desired font size
      ),
    ),
    shape: const Border(
      bottom: BorderSide(
        color: Colors.grey, // Desired border color
        width: 5, // Desired border width
      ),
    ),
  ),
),
              
            ),
          );

          // Mostrar la lista de elementos
          return ListView(
            children: items,
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
