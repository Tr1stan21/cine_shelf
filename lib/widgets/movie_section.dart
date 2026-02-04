import 'package:flutter/material.dart';
import 'package:cine_shelf/models/movie_item.dart';

class MovieListSection extends StatelessWidget {
  final String title;
  final List<MovieItem> items;

  MovieListSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.amber, // Color dorado
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.amber),
                onPressed: () {
                  // Acción para ver todo
                },
              ),
            ],
          ),

          // Lista de Pósters
          SizedBox(
            height: 200, // Tamaño fijo de la lista horizontal
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: 12,
                  ), // Espaciado entre imágenes
                  child: GestureDetector(
                    onTap: () {
                      // Acción al tocar un póster
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Bordes redondeados
                      child: Image.network(
                        items[index].imageUrl,
                        fit: BoxFit.cover, // Ajustar imagen al contenedor
                        width: 120, // Ancho fijo para las imágenes
                        height: 200, // Altura fija para las imágenes
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
