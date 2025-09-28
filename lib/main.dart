import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:el_juego_del_ahorcado/providers/game_provider.dart';
import 'package:el_juego_del_ahorcado/ui/screens/game_screen.dart';

void main() => runApp(const AhorcadoApp());

class AhorcadoApp extends StatelessWidget {
  const AhorcadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSeed = Colors.indigo;
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'El Ahorcado',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: colorSeed),
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: const GameScreen(),
      ),
    );
  }
}
