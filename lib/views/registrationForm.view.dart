// ignore_for_file: unused_field, sort_child_properties_last

import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // ignore: unused_field
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _cedula;
  String? _carrera;
  String? _foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de registro'),
        centerTitle: true,
        backgroundColor:
            Colors.red, // Cambia el color de fondo del appbar a rojo
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Cédula',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su cédula';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _cedula = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Correo'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor ingrese un correo válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstName = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Apellidos'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese sus apellidos';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lastName = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Carrera'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su carrera';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _carrera = value;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Link de la foto'),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un enlace';
                    }
                    if (!Uri.parse(value).isAbsolute) {
                      return 'Por favor ingrese un enlace válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _foto = value;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Guardar la información ingresada
                    }
                  },
                  child: const Text('Registrar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Cambia el color del botón a rojo
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 6),
                    textStyle: const TextStyle(fontSize: 20.0),
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
