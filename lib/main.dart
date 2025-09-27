import 'package:flutter/material.dart';

void main() => runApp(AhorcadoApp());

class AhorcadoApp extends StatelessWidget {
  const AhorcadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Juego del Ahorcado',
      home: Scaffold(
        appBar: AppBar(
          title: Text('El Juego del Ahorcado'),
        ),
        body: Center(
          child: Text('Bienvenido al Juego del Ahorcado!'),
        ),
      ),
    );
  }
  
}