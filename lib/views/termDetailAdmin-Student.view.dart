import 'package:flutter/material.dart';
import 'package:sashamaster/views/subject.view.dart';

import '../controllers/firebase.controller.dart';

// ignore: camel_case_types
class termDetailAdminStudent extends StatelessWidget {
  final int selectedSemesterIndex;

  final dynamic data;

  const termDetailAdminStudent(this.selectedSemesterIndex, this.data,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: GetCarreerByDoc(data['carreer']),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final dynamic carreer = snapshot.data!;
          final List<dynamic> subjects = carreer["subjects"];
          final List<String> codes = [];
          for (var i = 0; i < subjects.length; i++) {
            if (subjects[i]["term"] == (selectedSemesterIndex).toString()) {
              codes.add(subjects[i]["code"]);
            }
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Materias del Semestre $selectedSemesterIndex'),
            ),
            body: ListView.separated(
              itemCount: codes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                final subjectId = codes[index];

                return FutureBuilder<dynamic>(
                  future: GetSubjectByID(subjectId),
                  builder: (BuildContext context,
                      AsyncSnapshot<dynamic> subjectSnapshot) {
                    if (subjectSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (subjectSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${subjectSnapshot.error}'));
                    } else {
                      final subjectData = subjectSnapshot.data!;
                      final id=subjectSnapshot.data.id;
                      final subjectName = subjectData["name"];
                      
                      return ListTile(
                        title: Text(subjectName),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SubjectDetailsPage(subjectData, data, id),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
