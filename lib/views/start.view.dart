// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:sashamaster/controllers/firebase.controller.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StartPage createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  late Map<String, dynamic> data = {};
  // ignore: non_constant_identifier_names
  Future InitializeUser() async {
    data = await CurrentUser();
  }

  @override
  void initState() {
    super.initState();
    InitializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: const Text('Universidad de Medellín'),
        // Agrega un icono de menú hamburguesa en la barra de navegación
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: FutureBuilder<Map<String, dynamic>>(
                future: CurrentUser(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(data['photo']),
                            radius: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data["name"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text(
                          'No se pudo obtener la información del usuario');
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                // Agrega aquí la lógica para navegar a la pantalla de inicio
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                // Agrega aquí la lógica para navegar a la pantalla de configuración
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Contenido de mi pantalla'),
      ),
    );
  }
}
