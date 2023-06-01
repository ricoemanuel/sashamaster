import 'package:flutter/material.dart';

import '../controllers/firebase.controller.dart';

class SubjectDetailsPage extends StatelessWidget {
  final dynamic data;
  final dynamic student;
  final String id;

  const SubjectDetailsPage(this.data, this.student, this.id, {Key? key})
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
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return FormularioWidget(
                            idMateria: id,
                            idEstudiante: studentUid,
                            gradeData: {},
                            index: -1);
                      },
                    );
                  },
                ),
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
                          DataColumn(label: Text('Editar')),
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
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          print(index);
                                          return FormularioWidget(
                                              idMateria: id,
                                              idEstudiante: studentUid,
                                              gradeData: gradeData,
                                              index: index);
                                        },
                                      );
                                    },
                                  ),
                                ),
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

class FormularioWidget extends StatelessWidget {
  final String idMateria;
  final String idEstudiante;
  final dynamic gradeData;
  final int index;

  const FormularioWidget({
    Key? key,
    required this.idMateria,
    required this.idEstudiante,
    this.gradeData,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _actividadController = TextEditingController();
    final TextEditingController _notaController = TextEditingController();
    final TextEditingController _porcentajeController = TextEditingController();

    // Verificar si se proporcionó el atributo gradeData y establecer los valores en los controladores de texto
    if (gradeData != null) {
      _actividadController.text = gradeData['activity'] ?? '';
      _notaController.text = gradeData['grade']?.toString() ?? '';
      _porcentajeController.text = gradeData['porcentaje']?.toString() ?? '';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _actividadController,
            decoration: const InputDecoration(
              labelText: 'Actividad',
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _notaController,
            decoration: const InputDecoration(
              labelText: 'Nota',
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _porcentajeController,
            decoration: const InputDecoration(
              labelText: 'Porcentaje',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              // Acción para guardar los datos del formulario
              String activity = _actividadController.text;
              String gradeString = _notaController.text;
              String porcentajeString = _porcentajeController.text;
              double porcentaje = double.parse(porcentajeString);
              double grade = double.parse(gradeString);
              dynamic auxContext = context;
              dynamic bandera = false;
              if (grade >= 0 && grade <= 5) {
                if (porcentaje > 0 && porcentaje <= 1) {
                  dynamic notas = await GetGrades(idMateria, idEstudiante);
                  if (index < 0) {
                    if (notas.size > 0) {
                      notas.docs.forEach((doc) {
                        var nota = doc.data();
                        List<dynamic> gradesList = List.from(nota["grades"]);
                        double ponderado = 0;
                        gradesList.forEach((element) {
                          ponderado += element['porcentaje'];
                        });
                        ponderado += porcentaje;
                        if (ponderado <= 1) {
                          gradesList.add({
                            'activity': activity,
                            'grade': grade,
                            'porcentaje': porcentaje,
                          });
                          nota["grades"] = gradesList;
                          SetGrade(nota, doc.id);
                        } else {
                          bandera = true;
                        }
                      });
                    } else {
                      Map<String, dynamic> nota = {
                        'subject': idMateria,
                        'student': idEstudiante,
                        'grades': [],
                      };
                      List<dynamic> gradesList = List.from(nota["grades"]);
                      gradesList.add({
                        'activity': activity,
                        'grade': grade,
                        'porcentaje': porcentaje,
                      });
                      nota["grades"] = gradesList;

                      CreateGrade(nota);
                    }
                  } else {
                    notas.docs.forEach((doc) {
                      var nota = doc.data();
                      List<dynamic> gradesList = List.from(nota["grades"]);
                      double ponderado = 0;
                      gradesList.forEach((element) {
                        ponderado += element['porcentaje'];
                      });
                      ponderado += porcentaje;
                      ponderado -= nota["grades"][index]["porcentaje"];
                      if (ponderado > 1) {
                        bandera = true;
                      } else {
                        nota["grades"][index]["activity"] = activity;
                        nota["grades"][index]["grade"] = grade;
                        nota["grades"][index]["porcentaje"] = porcentaje;
                        SetGrade(nota, doc.id);
                      }
                    });
                  }
                  if (!bandera) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Cierra el showModalBottomSheet
                  } else {
                    showDialog(
                      context: auxContext,
                      builder: (BuildContext auxContext) {
                        return const RangoInvalidoDialog(
                            texto: 'La suma de los porcentajes sobrepasa 1');
                      },
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RangoInvalidoDialog(
                          texto:
                              'El número $porcentaje está fuera del rango válido (0-1).');
                    },
                  );
                }
              }else{
                showDialog(
                      context: auxContext,
                      builder: (BuildContext auxContext) {
                        return const RangoInvalidoDialog(
                            texto: 'La nota no puede ser mayor a 5 ni menor a 0');
                      },
                    );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

class RangoInvalidoDialog extends StatelessWidget {
  final String texto;

  const RangoInvalidoDialog({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    print(true);
    return AlertDialog(
      title: const Text('Advertencia'),
      content: Text(texto),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Aceptar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
