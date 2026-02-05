import 'package:flutter/material.dart';
import 'package:cine_shelf/widgets/background.dart';
import 'package:cine_shelf/models/movie_item.dart';

class MovieList extends StatelessWidget {
  final String title;
  final List<MovieItem> items;

  const MovieList({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    const posterAspectRatio = 2 / 3; // ancho/alto

    return Background(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: (items.length / 3).ceil(),
              itemBuilder: (context, rowIndex) {
                final start = rowIndex * 3;
                final end = (start + 3).clamp(0, items.length);
                final rowItems = items.sublist(start, end);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: List.generate(3, (i) {
                      if (i >= rowItems.length) {
                        return const Expanded(child: SizedBox());
                      }

                      final item = rowItems[i];

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {},
                            child: AspectRatio(
                              aspectRatio: posterAspectRatio,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
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
