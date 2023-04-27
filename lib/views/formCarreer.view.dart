import 'package:flutter/material.dart';
import 'package:sashamaster/controllers/firebase.controller.dart';

class CarreerForm extends StatefulWidget {
  const CarreerForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CarreerFormState createState() => _CarreerFormState();
}

class _CarreerFormState extends State<CarreerForm> {
  final _formKey = GlobalKey<FormState>();
  final _formKeySb = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final creditsController = TextEditingController();
  late List<Map<String, dynamic>> subjects = [];
  late String subjectName;
  late String subjectPoints;
  late String Name;
  late String Points;
  late String term;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    creditsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Carrera',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la carrera';
                  }
                  return null;
                },
                onSaved: (value) {
                  Name = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Créditos',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cantidad de créditos';
                  }
                  return null;
                },
                onSaved: (value) {
                  Points = value!;
                },
              ),
              const SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    const Text(
                      'Materias',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Créditos')),
                        DataColumn(label: Text('Semestre')),
                      ],
                      rows: List<DataRow>.generate(
                        subjects.length,
                        (int index) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(subjects[index]['name'])),
                            DataCell(Text(subjects[index]['points'])),
                            DataCell(Text(subjects[index]['term'])),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Form(
                        key: _formKeySb,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Materia',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese el nombre de la materia';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  subjectName = value!;
                                },
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Créditos',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese la cantidad de créditos';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  subjectPoints = value!;
                                },
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Semestre',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingrese el numero del semestre';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  term = value!;
                                },
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKeySb.currentState!.validate()) {
                                    _formKeySb.currentState!.save();
                                    setState(() {
                                      subjects.add({
                                        'name': subjectName,
                                        'points': subjectPoints,
                                        'term': term
                                      });
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: const Text('Agregar'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 6,
                                  ),
                                  textStyle: const TextStyle(fontSize: 20.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6),
                  textStyle: const TextStyle(fontSize: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    var carreer = {
                      'name': Name,
                      'points': Points,
                      'subjects': subjects
                    };
                    CreateCarreer(carreer);
                  }
                },
                child: const Text('Registrar'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 6),
                  textStyle: const TextStyle(fontSize: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
