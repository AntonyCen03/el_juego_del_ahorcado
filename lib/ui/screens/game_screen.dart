import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:el_juego_del_ahorcado/providers/game_provider.dart';
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
      backgroundColor: const Color(
        0xFFE0F2F1,
      ), // // Verde agua muy claro de fondo
      appBar: AppBar(
        backgroundColor: const Color(
          0xFFB2DFDB,
        ), // // Verde agua medio para el AppBar
        foregroundColor: const Color(
          0xFF004D40,
        ), // Texto verde oscuro para buen contraste
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
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            return isWide
                ? _buildWideLayout(context, gameProvider, isGameOver, won)
                : _buildVerticalLayout(
                    context,
                    gameProvider,
                    isGameOver,
                    won,
                    constraints: constraints,
                  );
          },
        ),
      ),
    );
  }

  Widget _buildStatsBar(GameProvider provider) {
    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 430; 
        final children = [
          _StatChip(
            label: 'Jugadas',
            value: provider.totalGamesPlayed.toString(),
            icon: Icons.analytics_outlined,
          ),
          _StatChip(
            label: 'Ganadas',
            value: provider.gamesWon.toString(),
            icon: Icons.emoji_events_outlined,
          ),
          _StatChip(
            label: 'Perdidas',
            value: provider.gamesLost.toString(),
            icon: Icons.sentiment_dissatisfied,
          ),
          _StatChip(
            label: 'Errores',
            value: provider.game.incorrectGuesses.toString(),
            icon: Icons.warning_amber_rounded,
          ),
        ];
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: narrow ? 12 : 40,
            vertical: 4,
          ),
          child: narrow
              ? Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 4,
                  children: children,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: children,
                ),
        );
      },
    );
  }

  Widget _buildWordSection(GameProvider provider) {
    final guess = provider.game.getCurrentGuess();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Evita overflow horizontal en teléfonos pequeños
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: WordDisplay(currentGuess: guess),
        ),
        const SizedBox(height: 12),
        AnimatedOpacity(
          opacity: provider.game.isGameOver ? 1 : 0.4,
          duration: const Duration(milliseconds: 400),
          child: Text(
            provider.game.isGameOver
                ? provider.game.secretWord.toUpperCase()
                : provider.game.currentHint,
            style: TextStyle(
              letterSpacing: guess.length > 18 ? 1.5 : 3,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.teal.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyboardOrResult(
    BuildContext context,
    GameProvider provider,
    bool isGameOver,
    bool won,
  ) {
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

  Widget _buildVerticalLayout(
    BuildContext context,
    GameProvider provider,
    bool isGameOver,
    bool won, {
    BoxConstraints? constraints,
  }) {
    final h = constraints?.maxHeight ?? MediaQuery.of(context).size.height;
    final short = h < 630; 
    final imageSide = (short ? h * 0.22 : h * 0.28).clamp(140, 240).toDouble();
    return Column(
      children: [
        const SizedBox(height: 4),
        _buildStatsBar(provider),
        Expanded(
          flex: short ? 4 : 3,
          child: Column(
            children: [
              SizedBox(
                height: imageSide,
                width: imageSide,
                child: HangmanImage(
                  incorrectGuesses: provider.game.incorrectGuesses,
                ),
              ),
              const SizedBox(height: 6),
              _buildWordSection(provider),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, short ? 0 : 8, 8, short ? 4 : 12),
            child: _buildKeyboardOrResult(context, provider, isGameOver, won),
          ),
        ),
      ],
    );
  }

  Widget _buildWideLayout(
    BuildContext context,
    GameProvider provider,
    bool isGameOver,
    bool won,
  ) {
    return Column(
      children: [
        // Estadísticas en toda la pantalla
        const SizedBox(height: 12),
        _buildStatsBar(provider),
        const SizedBox(height: 8),
        // Contenido principal en dos columnas
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HangmanImage(
                      incorrectGuesses: provider.game.incorrectGuesses,
                    ),
                    const SizedBox(height: 16),
                    _buildWordSection(provider),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildKeyboardOrResult(
                    context,
                    provider,
                    isGameOver,
                    won,
                  ),
                ),
              ),
            ],
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
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color.withValues(alpha: .15),
        child: Icon(icon, size: 16, color: color),
      ),
      label: Text('$label: $value'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

class _GameResult extends StatelessWidget {
  final bool won;
  final String secretWord;
  final VoidCallback onPlayAgain;
  const _GameResult({
    required this.won,
    required this.secretWord,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    final color = won ? Colors.green : Colors.red;
    final size = MediaQuery.of(context).size;
    final shortest = size.shortestSide; // base responsiva
    final titleFont = shortest < 340
        ? 20.0
        : shortest < 390
        ? 22.0
        : 24.0; // <=24 (menor que 26)
    final wordFont = (titleFont - 4).clamp(14.0, 20.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Text(
            won ? '¡GANASTE! 🎉' : 'DERROTA 😢',
            key: ValueKey(won),
            style: TextStyle(
              fontSize: titleFont,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Palabra: $secretWord',
          style: TextStyle(fontSize: wordFont, letterSpacing: 1.5),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: onPlayAgain,
          icon: const Icon(Icons.refresh),
          label: const Text('Jugar de nuevo'),
        ),
      ],
    );
  }
}

/// Widget que muestra las imágenes del ahorcado
class HangmanImage extends StatelessWidget {
  final int incorrectGuesses;

  const HangmanImage({super.key, required this.incorrectGuesses});

  @override
  Widget build(BuildContext context) {
    final index = incorrectGuesses.clamp(0, 6);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.of(context).size.height;
        final shortest = w < h ? w : h;
        double side = shortest * 0.4; 
        side = side.clamp(140, 300); 
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: SizedBox(
              height: side,
              width: side,
              child: Image.asset(
                'assets/images/hangman_$index.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Imagen $index\n(no encontrada)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
