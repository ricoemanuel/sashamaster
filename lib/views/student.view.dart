import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final List<dynamic> data;
  final int index;

  const CardWidget({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Center(
      child: CircleAvatar(
        backgroundImage: NetworkImage(data[index]['photo']),
        radius: 30,
      ),
    ),
    const SizedBox(height: 8),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data[index]['name'],
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          data[index]['carreer'],
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
    const SizedBox(height: 8),
    data[index]['state'] == "1"
        ? ElevatedButton(
            onPressed: () {
              // Lógica del botón "Aceptar"
            },
            child: Text('Aceptar'),
          )
        : SizedBox(),
  ],
);
}
}
