// Modelo simple para el juego del Ahorcado.
// Se encarga únicamente de la lógica: selección de palabra, registro de intentos y
// detección de estado (ganado/perdido).

class HangmanGame {
  /// Lista de palabras posibles con sus respectivas pistas.
  static const Map<String, String> _palabrasConPistas = {
    'manzana': 'Fruta roja',
    'banana': 'Fruta alargada',
    'naranja': 'Fruta cítrica',
    'pera': 'Fruta verde',
    'uva': 'Fruta morada',
    'sandia': 'Fruta gigante',
  };

  /// Lista de palabras posibles (todas en minúsculas).
  static List<String> get _palabras => _palabrasConPistas.keys.toList();

  /// Palabra secreta de la partida actual.
  String _secretWord = '';

  /// Conjunto de letras que el usuario ya intentó (correctas o no).
  Set<String> _guessedLetters = {};

  /// Número de intentos fallidos acumulados.
  int _incorrectGuesses = 0;

  /// Máximo de errores permitidos antes de perder la partida.
  static const int maxIncorrectGuesses = 6;

  /// Getter público para el máximo de errores permitidos (útil en la UI).
  int get maxErrors => maxIncorrectGuesses;

  /// Constructor: inicia automáticamente una nueva partida.
  HangmanGame() {
    _startNewGame();
  }

  /// Reinicia todos los valores internos para comenzar una nueva ronda.
  /// Usa un índice pseudo-aleatorio basado en DateTime. (Se podría mejorar usando Random()).
  void _startNewGame() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    final index = millis % _palabras.length;
    _secretWord = _palabras[index];
    _guessedLetters = {};
    _incorrectGuesses = 0;
  }

  /// Permite reiniciar desde fuera (UI / Provider).
  void restart() => _startNewGame();

  /// Procesa una letra ingresada. Devuelve true si la letra estaba en la palabra.
  /// - Normaliza a minúsculas.
  /// - No penaliza repetir la misma letra.
  bool guessLetter(String letter) {
    if (letter.isEmpty || isGameOver) return false;
    final normalized = letter[0].toLowerCase();
    final already = _guessedLetters.contains(normalized);
    if (already) return _secretWord.contains(normalized);

    _guessedLetters.add(normalized);
    final correct = _secretWord.contains(normalized);
    if (!correct) _incorrectGuesses++;
    return correct;
  }

  /// Devuelve la palabra secreta (normalmente no se muestra hasta terminar).
  String get secretWord => _secretWord;

  /// Devuelve la pista de la palabra actual.
  String get currentHint =>
      _palabrasConPistas[_secretWord] ?? 'Sin pista disponible';

  /// Cantidad de errores cometidos.
  int get incorrectGuesses => _incorrectGuesses;

  /// Indica si la partida terminó (ya sea por ganar o por exceder el límite de errores).
  bool get isGameOver =>
      _incorrectGuesses >= maxIncorrectGuesses || isWordGuessed;

  /// Indica si todas las letras han sido adivinadas.
  bool get isWordGuessed {
    for (final c in _secretWord.split('')) {
      if (!_guessedLetters.contains(c)) return false;
    }
    return true;
  }

  /// Devuelve la representación parcial (letras correctas y '_' para pendientes)
  /// separadas por espacios para una visualización más clara.
  String getCurrentGuess() {
    final buffer = <String>[];
    for (final ch in _secretWord.split('')) {
      buffer.add(_guessedLetters.contains(ch) ? ch.toUpperCase() : '_');
    }
    return buffer.join(' '); // Ej: F L U T T E R o _ L U _ _ E R
  }

  /// Devuelve el conjunto de letras intentadas hasta ahora.
  Set<String> get guessedLetters => _guessedLetters;
}
