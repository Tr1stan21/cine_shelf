import 'package:flutter/material.dart';

import 'package:cine_shelf/config/theme.dart';

/// Barra de búsqueda personalizada con estilo CineShelf
///
/// Campo de entrada con gradiente oscuro, placeholder e ícono de búsqueda.
class CineSearchBar extends StatelessWidget {
  const CineSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  static const String _searchHint = 'Buscar películas...';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CineRadius.xl),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 37, 39, 43), Color(0xFF131416)],
          ),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textAlignVertical: TextAlignVertical.center,
            style: CineTypography.bodyMedium,
            decoration: const InputDecoration(
              hintText: _searchHint,
              hintStyle: TextStyle(color: CineColors.textHint, fontSize: 16),
              contentPadding: EdgeInsets.symmetric(horizontal: CineSpacing.xl),
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search, color: CineColors.amber),
            ),
          ),
        ),
      ),
    );
  }
}
