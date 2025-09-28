// lib/ui/widgets/word_display.dart

import 'package:flutter/material.dart';

class WordDisplay extends StatelessWidget {
  final String currentGuess;

  const WordDisplay({required this.currentGuess, super.key});

  @override
  Widget build(BuildContext context) {
    // Usa Row (requisito) para alinear las letras horizontalmente.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // Se divide la cadena por los espacios generados en HangmanGame para tratar cada carácter por separado.
      children: currentGuess.split(' ').map((char) {
        // Padding para separar visualmente cada letra.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(
            char.isEmpty ? ' ' : char, 
            style: const TextStyle(
              fontSize: 40, 
              fontWeight: FontWeight.w700,
              letterSpacing: 4.0, 
            ),
          ),
        );
      }).toList(),
    );
  }
}