import 'package:flutter/material.dart';

/// Teclado reutilizable para el juego del ahorcado.
class HangmanKeyboard extends StatelessWidget {
	final Set<String> guessedLetters;
	final bool isGameOver;
	final void Function(String letter) onLetterTap;
	final String secretWord;

	const HangmanKeyboard({
		super.key,
		required this.guessedLetters,
		required this.isGameOver,
		required this.onLetterTap,
		required this.secretWord,
	});

	@override
	Widget build(BuildContext context) {
		const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		return GridView.builder(
			gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
				crossAxisCount: 7,
				childAspectRatio: 1.2,
			),
			itemCount: letters.length,
			itemBuilder: (context, index) {
				final letter = letters[index];
				final guessed = guessedLetters.contains(letter.toLowerCase());
				final correct = secretWord.contains(letter.toLowerCase());
				Color? bg;
				if (guessed) {
					bg = correct ? Colors.green[400] : Colors.red[400];
				}
				return Padding(
					padding: const EdgeInsets.all(4.0),
					child: ElevatedButton(
						onPressed: (guessed || isGameOver) ? null : () => onLetterTap(letter),
						style: ElevatedButton.styleFrom(
							backgroundColor: bg,
							foregroundColor: const Color.fromARGB(255, 60, 171, 234),
							disabledBackgroundColor: bg ?? const Color.fromARGB(255, 108, 103, 103),
						),
						child: Text(letter,
								style: const TextStyle(fontWeight: FontWeight.bold)),
					),
				);
			},
		);
	}
}
