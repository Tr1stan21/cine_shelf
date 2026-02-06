import 'package:flutter/material.dart';
import 'package:cine_shelf/models/movie_item.dart';
import 'package:cine_shelf/screens/movie_list.dart';
import 'package:cine_shelf/screens/movie_details.dart';

class MovieListSection extends StatelessWidget {
  final String title;
  final List<MovieItem> items;

  const MovieListSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    const postersVisible = 3;
    const itemSpacing = 12.0;
    const posterAspectRatio = 2 / 3; // ancho/alto

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.amber),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MovieList(title: title, items: items),
                    ),
                  );
                },
              ),
            ],
          ),

          // Lista (ancho calculado según el espacio REAL disponible)
          LayoutBuilder(
            builder: (context, constraints) {
              final availableW = constraints.maxWidth;
              final totalSpacing = itemSpacing * (postersVisible - 1);
              final posterW = (availableW - totalSpacing) / postersVisible;
              final posterH = posterW / posterAspectRatio;

              return SizedBox(
                height: posterH,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: itemSpacing),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: posterW,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => MovieDetails()),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            items[index].imageUrl,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
