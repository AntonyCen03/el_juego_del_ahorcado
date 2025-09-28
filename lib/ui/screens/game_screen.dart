import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:el_juego_del_ahorcado/providers/game_provider.dart';
import 'package:el_juego_del_ahorcado/ui/widgets/hangman_image.dart';
import 'package:el_juego_del_ahorcado/ui/widgets/word_display.dart';
import 'package:el_juego_del_ahorcado/ui/widgets/keyboard.dart';

/// Pantalla principal del juego con diseño adaptativo
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final game = gameProvider.game;
    final isGameOver = game.isGameOver;
    final won = game.isWordGuessed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('El Juego del Ahorcado'),
        actions: [
          IconButton(
            tooltip: 'Nueva partida',
            onPressed: () => gameProvider.startNewGame(),
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reset') {
                gameProvider.resetAll();
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'reset',
                child: Text('Reiniciar todo (estadísticas)'),
              ),
            ],
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return isWide
              ? _buildWideLayout(context, gameProvider, isGameOver, won)
              : _buildVerticalLayout(context, gameProvider, isGameOver, won);
        },
      ),
    );
  }

  Widget _buildStatsBar(GameProvider provider) {
    return Wrap(
      spacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _StatChip(label: 'Jugadas', value: provider.totalGamesPlayed.toString(), icon: Icons.analytics_outlined),
        _StatChip(label: 'Ganadas', value: provider.gamesWon.toString(), icon: Icons.emoji_events_outlined),
        _StatChip(label: 'Perdidas', value: provider.gamesLost.toString(), icon: Icons.sentiment_dissatisfied),
        _StatChip(label: 'Errores', value: provider.game.incorrectGuesses.toString(), icon: Icons.warning_amber_rounded),
      ],
    );
  }

  Widget _buildWordSection(GameProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WordDisplay(currentGuess: provider.game.getCurrentGuess()),
        const SizedBox(height: 12),
        AnimatedOpacity(
          opacity: provider.game.isGameOver ? 1 : 0.4,
            duration: const Duration(milliseconds: 400),
          child: Text(
            provider.game.isGameOver ? provider.game.secretWord.toUpperCase() : 'Adivina la palabra',
            style: const TextStyle(letterSpacing: 3, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyboardOrResult(BuildContext context, GameProvider provider, bool isGameOver, bool won) {
    if (isGameOver) {
      return _GameResult(
        won: won,
        secretWord: provider.game.secretWord.toUpperCase(),
        onPlayAgain: provider.startNewGame,
      );
    }
    return HangmanKeyboard(
      guessedLetters: provider.game.guessedLetters,
      isGameOver: isGameOver,
      secretWord: provider.game.secretWord,
      onLetterTap: provider.guessLetter,
    );
  }

  Widget _buildVerticalLayout(BuildContext context, GameProvider provider, bool isGameOver, bool won) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _buildStatsBar(provider),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                HangmanImage(incorrectGuesses: provider.game.incorrectGuesses),
                const SizedBox(height: 8),
                _buildWordSection(provider),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _buildKeyboardOrResult(context, provider, isGameOver, won),
          ),
        ),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context, GameProvider provider, bool isGameOver, bool won) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildStatsBar(provider),
              Expanded(
                child: Center(
                  child: HangmanImage(incorrectGuesses: provider.game.incorrectGuesses),
                ),
              ),
              const SizedBox(height: 8),
              _buildWordSection(provider),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildKeyboardOrResult(context, provider, isGameOver, won),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatChip({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Chip(
      avatar: CircleAvatar(backgroundColor: color.withValues(alpha: .15), child: Icon(icon, size: 16, color: color)),
      label: Text('$label: $value'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

class _GameResult extends StatelessWidget {
  final bool won;
  final String secretWord;
  final VoidCallback onPlayAgain;
  const _GameResult({required this.won, required this.secretWord, required this.onPlayAgain});

  @override
  Widget build(BuildContext context) {
    final color = won ? Colors.green : Colors.red;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
          child: Text(
            won ? '¡GANASTE! 🎉' : 'DERROTA 😢',
            key: ValueKey(won),
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('Palabra: $secretWord', style: const TextStyle(fontSize: 18, letterSpacing: 2)),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: onPlayAgain,
          icon: const Icon(Icons.refresh),
          label: const Text('Jugar de nuevo'),
        )
      ],
    );
  }
}
