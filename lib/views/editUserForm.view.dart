// ignore_for_file: unused_field, sort_child_properties_last

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/firebase.controller.dart';

class ProfileInformationEdition extends StatelessWidget {
  final dynamic data;
  const ProfileInformationEdition({Key? key, required this.data})
      : super(key: key);

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: data['id'] ?? '',
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Cédula',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su cédula';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    data['cedula'] = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: data['name'] ?? '',
                    ),
                  ),
                  decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    data['name'] = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: data['lastname'] ?? '',
                    ),
                  ),
                  decoration: InputDecoration(
                      labelText: 'Apellidos',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese sus apellidos';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    data['lastname'] = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: data['carreer'] ?? '',
                    ),
                  ),
                  decoration: InputDecoration(
                      labelText: 'Carrera',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su carrera';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    data['carreer'] = value;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      EditUser(data);
                    }
                  },
                  child: const Text('Registrar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Cambia el color del botón a rojo
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 6),
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
      ),
    );
  }
}
