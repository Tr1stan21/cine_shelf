import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
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
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Buscar películas...',
              hintStyle: const TextStyle(
                color: Color(0x99FFFFFF),
                fontSize: 16,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search, color: Color(0xFFCAA35C)),
            ),
          ),
        ),
      ),
    );
  }
}
