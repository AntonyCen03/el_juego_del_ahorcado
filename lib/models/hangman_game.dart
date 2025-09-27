// Modelo simple para el juego del Ahorcado.

class HangmanGame {
  /// Lista de palabras posibles (todas en minúsculas).
  static const List<String> _palabras = [
    'flutter',
    'dart',
    'widget',
    'state',
    'context',
    'provider',
    'inherited',
    'async',
    'future',
    'stream',
    'navigator',
    'scaffold',
    'appbar',
    'column',
    'row',
    'container',
    'padding',
    'margin',
    'alignment',
    'textfield',
    'button',
  ];

  /// Palabra secreta de la partida actual.
  String _secretWord = '';

  /// Conjunto de letras que el usuario ya intentó (correctas o no).
  Set<String> _guessedLetters = {};

  /// Número de intentos fallidos acumulados.
  int _incorrectGuesses = 0;

  /// Máximo de errores permitidos antes de perder la partida.
  static const int maxIncorrectGuesses = 6;


  /// Constructor: inicia automáticamente una nueva partida.
  HangmanGame(){
    _startNewGame();
  }

  /// Reinicia todos los valores internos para comenzar una nueva ronda.
  /// La selección de palabra usa el milisegundo actual para pseudo-"aleatoriedad".
  void _startNewGame(){
    _secretWord = _palabras[
      _palabras.length.ceil() * (DateTime.now().millisecond/1000)~/ 1 % _palabras.length
    ];
    _guessedLetters = {};
    _incorrectGuesses = 0;
  }

  /// Devuelve la palabra secreta (normalmente no se muestra hasta terminar).
  String get secretWord => _secretWord;

  /// Cantidad de errores cometidos.
  int get incorrectGuesses => _incorrectGuesses;

  /// Indica si la partida terminó (ya sea por ganar o por exceder el límite de errores).
  bool get isGameOver => _incorrectGuesses >= maxIncorrectGuesses || isWordGuessed;

  /// Indica si todas las letras han sido adivinadas.
  bool get isWordGuessed => getCurrentGuess().replaceAll(' ', '') == _secretWord;

  /// Devuelve la representación parcial (letras adivinadas y '_' para pendientes).
  String getCurrentGuess(){
    String display = '';
    for (var letter in _secretWord.runes) {
      final char = String.fromCharCode(letter);
      if (_guessedLetters.contains(char)) {
        display += char;
      } else {
        display += '_';
      }
    }
    return display.trim();
  }

  /// Devuelve el conjunto de letras intentadas hasta ahora.
  Set<String> get guessedLetters => _guessedLetters;
}