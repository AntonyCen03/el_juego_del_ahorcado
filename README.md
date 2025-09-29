
# El Juego del Ahorcado

Juego clásico del ahorcado desarrollado en Flutter, con soporte multiplataforma (Android, Windows, Web, macOS, Linux). El objetivo es adivinar la palabra secreta antes de alcanzar el límite de errores.

## Características

- **Interfaz adaptativa**: Se ajusta automáticamente a móviles, tablets y escritorios.
- **Estadísticas persistentes**: Guarda partidas jugadas y ganadas usando `shared_preferences`.
- **Teclado virtual**: Permite seleccionar letras fácilmente.
- **Imágenes del ahorcado**: Cambian según los errores cometidos.
- **Pistas**: Cada palabra tiene una pista para ayudar al jugador.
- **Modo oscuro y accesibilidad**: Compatible con Material 3.

## Estructura del Proyecto

- `lib/main.dart`: Punto de entrada. Configura el tema y el provider.
- `lib/models/hangman_game.dart`: Lógica principal del juego (palabra secreta, intentos, estado).
- `lib/providers/game_provider.dart`: Maneja el estado global y las estadísticas.
- `lib/services/score_manager.dart`: Persistencia local de puntajes.
- `lib/ui/screens/game_screen.dart`: Pantalla principal, diseño responsive.
- `lib/ui/widgets/keyboard.dart`: Teclado virtual de letras.
- `lib/ui/widgets/word_display.dart`: Muestra el progreso de la palabra.
- `lib/ui/widgets/hangman_image.dart`: Renderiza la imagen correspondiente al estado del juego.

## Instalación y Ejecución

1. **Clona el repositorio**:
	```powershell
	git clone https://github.com/AntonyCen03/el_juego_del_ahorcado.git
	```

2. **Instala dependencias**:
	```powershell
	flutter pub get
	```

3. **Ejecuta el proyecto**:
	```powershell
	flutter run
	```
	Puedes seleccionar el dispositivo (emulador, web, escritorio) desde tu IDE o con el flag `-d`.

## Recursos y Personalización

- Las imágenes del ahorcado deben estar en `assets/images/h0.png` a `h6.png`.
- Puedes modificar las palabras y pistas en `lib/models/hangman_game.dart`.
- Los colores y estilos se pueden ajustar en `lib/ui/screens/game_screen.dart`.

## Créditos

Desarrollado por AntonyCen03 y edusye.  
Basado en Flutter 3.9.2 y Dart 3.9.2.
