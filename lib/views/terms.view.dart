import 'package:flutter/material.dart';
import 'package:sashamaster/views/termDetail.view.dart';

import '../controllers/firebase.controller.dart';

// ignore: camel_case_types
class term extends StatefulWidget {
  const term({Key? key}) : super(key: key);

  @override
  State<term> createState() => _termState();
}

// ignore: camel_case_types
class _termState extends State<term> {
  // Definir una variable para el índice del semestre seleccionado
  int selectedSemesterIndex = -1;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: CurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final terms = data["term"];
          final List<Widget> rows = List.generate(
            (terms / 2).ceil(),
            (rowIndex) {
              final int startIndex = rowIndex * 2;
              final int endIndex = startIndex + 1;
              final List<Widget> rowItems = List.generate(
                2,
                (columnIndex) {
                  final index = startIndex + columnIndex;
                  if (index < terms) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSemesterIndex = index;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                termDetail(selectedSemesterIndex, data),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        margin: const EdgeInsets.only(top: 16.0, right: 16.0),
                        width: 150,
                        height: 100,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          title: Text(
                            'Semestre ${index + 1}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: rowItems,
              );
            },
          );
          return ListView(
            children: rows,
          );
        } else if (snapshot.hasError) {
          return const Text('Error al obtener los datos');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
