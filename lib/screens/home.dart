import 'package:flutter/material.dart';

// Constantes editables para ajustes visuales rápidos
// Ajusta opacidades si el efecto es muy fuerte o muy sutil.
const double kLightLeakOpacity = 0.20;
const double kGrainOpacity = 0.045;
const double kWarmTintOpacity = 0.06;
const double kBottomNavHeight = 72;
const Color kAmber = Color(0xFFFF9A2E);
const Color kGold = Color(0xFFD7B06A);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<int> _latest = [0, 1, 2, 3, 4, 5];
  static const List<int> _watchlist = [0, 1, 2, 3, 4];
  static const List<int> _favorites = [0, 1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _BackgroundWithOverlays(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: _Header()),
                const SliverToBoxAdapter(child: _SearchBar()),
                const SliverToBoxAdapter(child: _GlowDivider()),
                SliverToBoxAdapter(
                  child: _Section(title: 'Últimos estrenos', posters: _latest),
                ),
                const SliverToBoxAdapter(child: _GlowDivider()),
                SliverToBoxAdapter(
                  child: _Section(title: 'Por ver', posters: _watchlist),
                ),
                const SliverToBoxAdapter(child: _GlowDivider()),
                SliverToBoxAdapter(
                  child: _Section(title: 'Favoritas ★', posters: _favorites),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: kBottomNavHeight + 16),
                  sliver: const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(top: false, child: _BottomNav()),
    );
  }
}

class _BackgroundWithOverlays extends StatelessWidget {
  const _BackgroundWithOverlays();

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Base oscuro con tinte cálido + overlays cinematográficos.
            Positioned.fill(child: _DarkGradientBackground()),
            Positioned.fill(child: _WarmTintOverlay()),
            Positioned.fill(child: _LightLeakOverlay()),
            Positioned.fill(child: _GrainOverlay()),
          ],
        ),
      ),
    );
  }
}

class _DarkGradientBackground extends StatelessWidget {
  const _DarkGradientBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF050405), Color(0xFF0B0607), Color(0xFF050507)],
        ),
      ),
    );
  }
}

class _LightLeakOverlay extends StatelessWidget {
  const _LightLeakOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Opacity(
        opacity: kLightLeakOpacity,
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Color(0xFFFFC08A),
            BlendMode.screen,
          ),
          child: Image.asset(
            'assets/overlays/light_leak.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
          ),
        ),
      ),
    );
  }
}

class _GrainOverlay extends StatelessWidget {
  const _GrainOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Opacity(
        opacity: kGrainOpacity,
        child: ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.softLight,
          ),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/overlays/grain_tile.png'),
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WarmTintOverlay extends StatelessWidget {
  const _WarmTintOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Opacity(
        opacity: kWarmTintOpacity,
        child: const ColoredBox(color: Color(0xFFFF6A00)),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
      child: Column(
        children: [
          Image.asset(
            'assets/logo/cineshelf_logo.png',
            height: 78,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.low,
          ),
          const SizedBox(height: 10),
          Text(
            'CineShelf',
            style: const TextStyle(
              fontSize: 30,
              color: kGold,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              shadows: [Shadow(color: Color(0x66FF9A2E), blurRadius: 14)],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search, color: Colors.white.withOpacity(0.55), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Buscar películas…',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.40),
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 6),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66FF9A2E),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.search, color: kAmber, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowDivider extends StatelessWidget {
  const _GlowDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            kAmber.withOpacity(0.35),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: kAmber.withOpacity(0.25),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<int> posters;

  const _Section({required this.title, required this.posters});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: kGold,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.chevron_right, color: kAmber.withOpacity(0.75)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 132,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: posters.length,
              itemBuilder: (context, index) {
                return _PosterPlaceholder(index: posters[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  final int index;

  const _PosterPlaceholder({required this.index});

  @override
  Widget build(BuildContext context) {
    final Color endColor =
        Color.lerp(
          const Color(0xFF2A1D1A),
          const Color(0xFF3A2722),
          (index % 5) / 4,
        ) ??
        const Color(0xFF2A1D1A);

    return Container(
      width: 92,
      height: 132,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF181010), endColor],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
              ),
            ),
            Positioned(
              left: -20,
              top: 0,
              bottom: 0,
              child: Container(
                width: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0C).withOpacity(0.90),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 14,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _NavItem(icon: Icons.home, label: 'Inicio', isActive: true),
          _NavItem(icon: Icons.playlist_play, label: 'Mis listas'),
          _NavItem(icon: Icons.person_outline, label: 'Cuenta'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = kAmber;
    final Color inactiveColor = Colors.white.withOpacity(0.38);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Color(0x66FF9A2E),
                      blurRadius: 14,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isActive ? activeColor : inactiveColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : inactiveColor,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
