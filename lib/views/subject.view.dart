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
      body: FutureBuilder<dynamic>(
        future: GetGrades(id, studentUid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> gradesSnapshot) {
          if (gradesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (gradesSnapshot.hasError) {
            return Center(child: Text('Error: ${gradesSnapshot.error}'));
          } else {
            final docs =
                gradesSnapshot.data!.docs.map((doc) => doc.data()).toList();
            final gradesList = docs[0]["grades"];

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
                            index: 0);
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

class FormularioWidget extends StatefulWidget {
  final String idMateria;
  final String idEstudiante;
  final dynamic gradeData;
  final int index;
  const FormularioWidget(
      {Key? key,
      required this.idMateria,
      required this.idEstudiante,
      this.gradeData,
      required this.index})
      : super(key: key);

  @override
  _FormularioWidgetState createState() => _FormularioWidgetState();
}

class _FormularioWidgetState extends State<FormularioWidget> {
  final TextEditingController _actividadController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();
  final TextEditingController _porcentajeController = TextEditingController();

  get idMateria => null;

  get idEstudiante => null;

  @override
  void initState() {
    super.initState();

    // Verificar si se proporcionó el atributo gradeData y establecer los valores en los controladores de texto
    if (widget.gradeData != null) {
      _actividadController.text = widget.gradeData['activity'] ?? '';
      _notaController.text = widget.gradeData['grade']?.toString() ?? '';
      _porcentajeController.text =
          widget.gradeData['porcentaje']?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              String actividad = _actividadController.text;
              String nota = _notaController.text;
              String porcentaje = _porcentajeController.text;
              dynamic notas = await GetGrades(idMateria, idEstudiante);
              notas.docs.forEach((doc) {
                print(doc.data());
              });

              Navigator.pop(context); // Cierra el showModalBottomSheet
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
