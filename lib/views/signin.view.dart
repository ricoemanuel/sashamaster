import 'package:flutter/material.dart';
import 'package:sashamaster/controllers/firebase.controller.dart';

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
      print(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de sesión'),
      ),
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
