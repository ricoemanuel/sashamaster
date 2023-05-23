import 'package:flutter/material.dart';

import '../controllers/firebase.controller.dart';

class SubjectDetailsStudentPage extends StatelessWidget {
  final dynamic data;
  final dynamic student;
  final String id;

  const SubjectDetailsStudentPage(this.data, this.student, this.id, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subjectName = data['name'];
    final studentUid = student['uid'];

    return Scaffold(
      appBar: AppBar(
        title: Text(subjectName),
      ),
      body: StreamBuilder<dynamic>(
        stream: GetGradesStream(id, studentUid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> gradesSnapshot) {
          if (gradesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (gradesSnapshot.hasError) {
            return Center(child: Text('Error: ${gradesSnapshot.error}'));
          } else {
            final docs =
                gradesSnapshot.data!.docs.map((doc) => doc.data()).toList();
            List<dynamic> gradesList = docs.length < 1 ? [] : docs[0]["grades"];
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(), // Scroll infinito
                    padding: const EdgeInsets.all(16),
                    children: [
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Actividad')),
                          DataColumn(label: Text('Nota')),
                          DataColumn(label: Text('%')),
                          
                        ],
                        rows: List<DataRow>.generate(
                          gradesList.length,
                          (index) {
                            final gradeData = gradesList[index];
                            final activity = gradeData['activity'];
                            final grade = gradeData['grade'];
                            final porcentaje = gradeData['porcentaje'];
                            return DataRow(
                              cells: [
                                DataCell(Text(activity)),
                                DataCell(Text(grade.toString())),
                                DataCell(Text(porcentaje.toString())),
                        
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

