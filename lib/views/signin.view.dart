import 'package:flutter/material.dart';
import 'package:sashamaster/controllers/firebase.controller.dart';
import 'start.view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late String _email = "";
  late String _password = "";

  Future<dynamic> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var user = await SignIn(_email, _password);
      if (user == 1) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Usted no tiene cuenta'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (user == 2) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Contraseña incorrecta'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        // ignore: unrelated_type_equality_checks
      } else if (user.runtimeType == String) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StartPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  // Validación del correo electrónico
                  if (value!.isEmpty ||
                      !RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                          .hasMatch(value)) {
                    return 'Ingresa un correo electrónico válido';
                  } else {
                    _email = value;
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  // Validación de la contraseña
                  if (value!.isEmpty || value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  } else {
                    _password = value;
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Iniciar sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
