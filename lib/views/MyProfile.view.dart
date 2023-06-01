import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/firebase.controller.dart';
import 'editUserForm.view.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: CurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = FirebaseAuth.instance.currentUser?.uid;
          final data = snapshot.data!;
          data['uid'] = user;
          var nombre = '${data['name']} ${data['lastname']}';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('lib/images/campus.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 200,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16),
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage('lib/images/perfil.png'),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombre.length > 20
                                  ? '${nombre.substring(0, 20)}...'
                                  : nombre,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoItem('Carrera', data['carreer']),
                          _buildInfoItem('Carga horaria', data['charge']),
                          _buildInfoItem('ID', data['id']),
                          _buildInfoItem('Estado', data['state']),
                          _buildInfoItem('Semestre', data['term'].toString()),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      title: Text(data['name']),
                                    ),
                                    body: ProfileInformationEdition(
                                      data: data,
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  )),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('Error al obtener los datos');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildInfoItem(String label, String value) {
    if (label == 'Estado') {
      if (value == '1') {
        value = 'No aceptado';
      } else if (value == '2') {
        value = 'Aceptado';
      }
    }
    if (label == "Carrera" && value!="n/a") {
      return FutureBuilder<dynamic>(
        future: GetCarreerByDoc(value),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dynamic carreer = snapshot.data!.data();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      carreer != null ? carreer['name'] : '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    }
  }
}
