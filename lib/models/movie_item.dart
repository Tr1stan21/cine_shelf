class MovieItem {
  final String title; // Título de la película
  final String imageUrl; // URL de la imagen del póster
  final String
  id; // ID único para identificar la película (opcional, útil para la navegación)

  // Constructor
  MovieItem({required this.title, required this.imageUrl, required this.id});

  // Si necesitas métodos adicionales, añádelos aquí de forma sencilla
  // Ejemplo: un método para obtener el nombre completo de la película
  String get fullTitle => '$title (Detalles)';
}
