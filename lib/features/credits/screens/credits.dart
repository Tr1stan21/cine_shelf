import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/back_button.dart';
import 'package:cine_shelf/shared/widgets/background.dart';

/// Credits and app information screen.
///
/// Displays:
/// - App info card with icon, name, version, and description
/// - Technologies used section
/// - APIs and services section
/// - Developer information
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Background(
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              padding: EdgeInsets.all(CineSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),

                  // Title
                  Text(
                    'Credits',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: CineColors.amber,
                    ),
                  ),

                  SizedBox(height: CineSpacing.xxl),

                  // App Info Card
                  _AppInfoCard(),

                  SizedBox(height: CineSpacing.xxxl),

                  // Technologies Section
                  _SectionHeader(icon: Icons.code, title: 'Technologies used'),
                  SizedBox(height: CineSpacing.lg),
                  _TechItem(
                    name: 'Flutter',
                    subtitle: 'Framework',
                    version: '3.29.0',
                  ),
                  _TechItem(
                    name: 'Dart',
                    subtitle: 'Language',
                    version: '3.10.1',
                  ),
                  _TechItem(
                    name: 'Go Router',
                    subtitle: 'Navigation',
                    version: '17.1.0',
                  ),
                  _TechItem(
                    name: 'Riverpod',
                    subtitle: 'State Management',
                    version: '3.2.1',
                  ),
                  _TechItem(
                    name: 'Firebase',
                    subtitle: 'Backend Services',
                    version: '4.4.0',
                  ),

                  SizedBox(height: CineSpacing.xxxl),

                  // APIs & Services Section
                  _SectionHeader(icon: Icons.api, title: 'APIs and services'),
                  SizedBox(height: CineSpacing.lg),
                  _TechItem(
                    name: 'The Movie Database (TMDB)',
                    subtitle: 'Movie database',
                  ),

                  SizedBox(height: CineSpacing.xxxl),

                  // Developed By Section
                  _SectionHeader(
                    icon: Icons.person_outline,
                    title: 'Developed by',
                  ),
                  SizedBox(height: CineSpacing.lg),
                  Text(
                    'Javier Tristán Chacón Domínguez',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: CineColors.textLight,
                    ),
                  ),

                  SizedBox(height: CineSpacing.xxl),
                ],
              ),
            ),

            // Back button overlay
            Padding(padding: EdgeInsets.all(16.0), child: CineBackButton()),
          ],
        ),
      ),
    );
  }
}

/// App information card with icon, name, version, and description.
class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CineSpacing.xl),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1715),
        borderRadius: BorderRadius.circular(CineRadius.md),
        border: Border.all(
          color: CineColors.amber.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App icon placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CineColors.amber.withValues(alpha: 0.15),
              border: Border.all(
                color: CineColors.amber.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/logo/logo.png',
                width: 34,
                height: 34,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: CineSpacing.lg),

          // App info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CineShelf',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: CineColors.amber,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 13, color: CineColors.textMuted),
                ),
                const SizedBox(height: CineSpacing.md),
                Text(
                  'A modern movie tracking app for discovering, organizing, and managing your personal film collection.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: CineColors.textLight.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header with icon and title.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: CineColors.amber),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CineColors.amber,
          ),
        ),
      ],
    );
  }
}

/// Technology/service list item with name, subtitle, and optional version.
class _TechItem extends StatelessWidget {
  const _TechItem({required this.name, required this.subtitle, this.version});

  final String name;
  final String subtitle;
  final String? version;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CineSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.circle, size: 6, color: CineColors.amber),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: CineColors.textLight,
                        ),
                      ),
                    ),
                    if (version != null)
                      Text(
                        'v$version',
                        style: TextStyle(
                          fontSize: 13,
                          color: CineColors.textMuted.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CineColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
