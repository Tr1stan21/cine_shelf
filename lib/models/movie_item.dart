/// Modelo de datos para un item de película
///
/// Representa la información básica de una película que se muestra
/// en listas y carruseles de la aplicación.
class MovieItem {
  const MovieItem({
    required this.title,
    required this.imageUrl,
    required this.id,
  });

  /// Título de la película
  final String title;

  /// URL de la imagen del póster
  final String imageUrl;

  /// ID único para identificar la película
  final String id;
}
