import 'package:flutter/material.dart';
import 'package:el_juego_del_ahorcado/models/hangman_game.dart';
import 'package:el_juego_del_ahorcado/services/score_manager.dart';

/// Provider que expone el estado del juego y maneja la persistencia de puntajes.
class GameProvider with ChangeNotifier {
  HangmanGame _game = HangmanGame();
  int _totalGamesPlayed = 0;
  int _gamesWon = 0;
  late final ScoreManager _scoreManager;

  GameProvider() {
    _scoreManager = ScoreManager();
    _loadScores();
  }

  // Getters públicos
  HangmanGame get game => _game;
  int get totalGamesPlayed => _totalGamesPlayed;
  int get gamesWon => _gamesWon;
  int get gamesLost => _totalGamesPlayed - _gamesWon;

  Future<void> _loadScores() async {
    final scores = await _scoreManager.loadScores();
    _totalGamesPlayed = scores['played'] ?? 0;
    _gamesWon = scores['won'] ?? 0;
    notifyListeners();
  }

  /// Procesa la letra seleccionada y actualiza marcadores si se termina la partida.
  void guessLetter(String letter) {
    final beforeGameOver = _game.isGameOver;
    if (beforeGameOver) return; // Ignora si ya terminó.

    _game.guessLetter(letter);

    if (_game.isGameOver) {
      _totalGamesPlayed++;
      if (_game.isWordGuessed) {
        _gamesWon++;
      }
      _scoreManager.saveScores(_totalGamesPlayed, _gamesWon);
    }
    notifyListeners();
  }

  /// Inicia una nueva partida manteniendo las estadísticas acumuladas.
  void startNewGame() {
    _game.restart();
    notifyListeners();
  }

  /// Reinicia completamente todo (incluye estadísticas) y limpia persistencia.
  Future<void> resetAll() async {
    _totalGamesPlayed = 0;
    _gamesWon = 0;
    _game = HangmanGame();
    await _scoreManager.saveScores(0, 0);
    notifyListeners();
  }
}