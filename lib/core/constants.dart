/// Constantes globales del app CineShelf
abstract class AppConstants {
  // Assets paths
  static const String logoPath = 'assets/logo/logo_extracted.png';
  static const String background = 'assets/images/background.png';

  // URLs placeholder (temporal hasta integrar API real)
  static const String urlPlaceholderPoster =
      'https://img.freepik.com/foto-gratis/abstracto-lujo-plano-borroso-gris-negro-gradiente-utilizado-como-pared-estudio-fondo-mostrar-sus-productos_1258-101806.jpg?t=st=1770232643~exp=1770236243~hmac=3609abae0072ff030394bdd554e53da3857969388a5dd856fd5c3608302051a1';

  // Tamaños y proporciones
  static const double posterAspectRatio = 2 / 3;
  static const int moviesPerRow = 3;
  static const int postersVisible = 3;
  static const double itemSpacing = 12.0;
}
