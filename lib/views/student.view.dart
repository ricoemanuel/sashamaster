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
        const SizedBox(height: 20),
        Center(
          child: Container(
            height: 380,
            width: 380,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(data[index]['photo']),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${data[index]['name']}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${data[index]['carreer']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: data[index]['state'] == "1"
              ? ElevatedButton(
                  onPressed: () {
                    // Lógica del botón "Aceptar"
                  },
                  child: Text('Aceptar', style: const TextStyle(fontSize: 18)),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
