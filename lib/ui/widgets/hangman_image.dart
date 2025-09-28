// lib/ui/widgets/hangman_image.dart

import 'package:flutter/material.dart';

class HangmanImage extends StatelessWidget {
  final int incorrectGuesses;

  const HangmanImage({required this.incorrectGuesses, super.key});

  @override
  Widget build(BuildContext context) {
    // Asegura que el índice de la imagen esté dentro del rango [0, 6].
    final errorCount = incorrectGuesses.clamp(0, 6); 
    
    //  La ruta asume que tienes las imágenes 'h0.png' a 'h6.png' en 'assets/images/'.
    // ¡Recuerda declarar la carpeta 'assets' en tu pubspec.yaml!
    final imagePath = 'assets/images/h$errorCount.png';

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Center(
        child: Image.asset(
          imagePath,
          height: 250,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 250,
              width: 250,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'IMAGEN $errorCount',
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}