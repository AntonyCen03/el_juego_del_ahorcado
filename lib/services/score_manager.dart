import 'package:shared_preferences/shared_preferences.dart';

/// Maneja la persistencia local de estadísticas de partidas.
class ScoreManager {
  static const String _keyPlayed = 'total_games_played';
  static const String _keyWon = 'total_games_won';

  Future<Map<String, int>> loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final played = prefs.getInt(_keyPlayed) ?? 0;
    final won = prefs.getInt(_keyWon) ?? 0;
    return {
      'played': played,
      'won': won,
    };
  }

  Future<void> saveScores(int played, int won) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPlayed, played);
    await prefs.setInt(_keyWon, won);
  }
}