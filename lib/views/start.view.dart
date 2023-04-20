// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:sashamaster/controllers/firebase.controller.dart';
import 'package:sashamaster/main.dart';
import 'package:sashamaster/views/signin.view.dart';
import 'package:sashamaster/views/home.view.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StartPage createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  int selectedPage = 0;
  final List<Widget> _pages = [const home()];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: CurrentUser(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            return Scaffold(
              body: _pages[selectedPage],
              key: _scaffoldKey,
              endDrawerEnableOpenDragGesture: false,
              appBar: AppBar(
                title: const Text('Universidad de Medellín'),
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
                        color: Colors.red,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(data['photo']),
                            radius: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data["name"][0].toUpperCase() +
                                data["name"].substring(1) +
                                " " +
                                data["lastname"]
                                    .split(" ")[0][0]
                                    .toUpperCase() +
                                data["lastname"].split(" ")[0].substring(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    snapshot.hasData
                        ? ListTile(
                            leading: const Icon(Icons.home),
                            title: const Text('Inicio'),
                            selected: selectedPage == 0,
                            onTap: () {
                              setState(() {
                                selectedPage = 0;
                              });
                              Navigator.pop(context);
                            },
                          )
                        : Container(),
                    data["charge"] == "admin"
                        ? ListTile(
                            leading: const Icon(
                                Icons.supervised_user_circle_rounded),
                            title: const Text('Estudiantes'),
                            onTap: () {
                              // Agrega aquí la lógica para navegar a la pantalla de inicio
                            },
                          )
                        : Container(),
                    snapshot.hasData && data["charge"] == "estudiante"
                        ? ListTile(
                            leading: const Icon(Icons.book),
                            title: const Text('Semestres'),
                            onTap: () {
                              // Agrega aquí la lógica para navegar a la pantalla de configuración
                            },
                          )
                        : Container(),
                    snapshot.hasData
                        ? ListTile(
                            leading: const Icon(Icons.supervised_user_circle),
                            title: const Text('Mi perfil'),
                            onTap: () {
                              // Agrega aquí la lógica para navegar a la pantalla de configuración
                            },
                          )
                        : Container(),
                    snapshot.hasData
                        ? ListTile(
                            leading: const Icon(Icons.logout_rounded),
                            title: const Text('Cerrar sesión'),
                            onTap: () async {
                              var response = await LogOut();
                              if (response) {
                                // ignore: use_build_context_synchronously
                                changeView(context, const MyApp());
                              }
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
                child: Text('No se pudo obtener la información del usuario'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

void changeView(BuildContext context, Widget ventana) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => ventana),
  );
}
