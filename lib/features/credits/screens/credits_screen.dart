import 'package:cine_shelf/features/credits/widgets/app_info_card.dart';
import 'package:cine_shelf/features/credits/widgets/section_header.dart';
import 'package:cine_shelf/features/credits/widgets/tech_item.dart';
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
                  AppInfoCard(),

                  SizedBox(height: CineSpacing.xxxl),

                  // Technologies Section
                  SectionHeader(icon: Icons.code, title: 'Technologies used'),
                  SizedBox(height: CineSpacing.lg),
                  TechItem(
                    name: 'Flutter',
                    subtitle: 'Framework',
                    version: '3.29.0',
                  ),
                  TechItem(
                    name: 'Dart',
                    subtitle: 'Language',
                    version: '3.10.1',
                  ),
                  TechItem(
                    name: 'Go Router',
                    subtitle: 'Navigation',
                    version: '17.1.0',
                  ),
                  TechItem(
                    name: 'Riverpod',
                    subtitle: 'State Management',
                    version: '3.2.1',
                  ),
                  TechItem(
                    name: 'Firebase',
                    subtitle: 'Backend Services',
                    version: '4.4.0',
                  ),

                  SizedBox(height: CineSpacing.xxxl),

                  // APIs & Services Section
                  SectionHeader(icon: Icons.api, title: 'APIs and services'),
                  SizedBox(height: CineSpacing.lg),
                  TechItem(
                    name: 'The Movie Database (TMDB)',
                    subtitle: 'Movie database',
                  ),

                  SizedBox(height: CineSpacing.xxxl),

                  // Developed By Section
                  SectionHeader(
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
