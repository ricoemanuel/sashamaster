import 'package:flutter/material.dart';

class CarreerForm extends StatefulWidget {
  const CarreerForm({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CarreerFormState createState() => _CarreerFormState();
}

class _CarreerFormState extends State<CarreerForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final creditsController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    creditsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Nombre de la carrera:',
            style: TextStyle(fontSize: 18.0),
          ),
          TextFormField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un nombre de carrera';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Créditos:',
            style: TextStyle(fontSize: 18.0),
          ),
          TextFormField(
            controller: creditsController,
            decoration: InputDecoration(
              labelText: 'Créditos',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese los créditos requeridos';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid, so do something
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
