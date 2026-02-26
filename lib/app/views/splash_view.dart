// lib/app/views/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../routes/app_routes.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  static const _ferrariUrl =
      'https://w0.peakpx.com/wallpaper/887/313/HD-wallpaper-ferrari-lines-car-ferrari-458-ferrari-488-ferrari-f12-ferrari-hybrid-ferrari-sf90-hybrid-ferrari-laferrari-red-thumbnail.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Ferrari Amalfi full-bleed ──
          // FIX: usar color + colorBlendMode en lugar de colorFilter
          Image.asset(
            'assets/images/ferrari.jpg',
            fit:            BoxFit.cover,
            alignment:      Alignment.centerLeft,
            color:          Colors.black.withValues(alpha: 0.45),
            colorBlendMode: BlendMode.darken,
          ),

          // ── Gradient overlay ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin:  Alignment.topCenter,
                end:    Alignment.bottomCenter,
                stops: [0.0, 0.45, 0.75, 1.0],
                colors: [
                  Color(0x00000000),
                  Color(0x1A000000),
                  Color(0xD9000000),
                  AppColors.black,
                ],
              ),
            ),
          ),

          // ── Content ──
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: ShieldBadge(size: 52),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 0, 26, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Registra Tu\n',
                              style: TextStyle(
                                fontFamily:   'Inter',
                                fontSize:     34,
                                fontWeight:   FontWeight.w900,
                                color:        AppColors.white,
                                letterSpacing: -.5,
                                height:       1.1,
                              ),
                            ),
                            TextSpan(
                              text: 'Combustible\n',
                              style: TextStyle(
                                fontFamily:   'Inter',
                                fontSize:     34,
                                fontWeight:   FontWeight.w900,
                                color:        AppColors.yellow,
                                letterSpacing: -.5,
                                height:       1.1,
                              ),
                            ),
                            TextSpan(
                              text: 'Con Estilo',
                              style: TextStyle(
                                fontFamily:   'Inter',
                                fontSize:     34,
                                fontWeight:   FontWeight.w900,
                                color:        AppColors.white,
                                letterSpacing: -.5,
                                height:       1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Controla cada recarga y monitorea el rendimiento\nde tu vehículo en tiempo real.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize:   14,
                          color:      Color(0x99FFFFFF),
                          height:     1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => Get.offNamed(Routes.HOME),
                        child: Container(
                          width:  52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppColors.yellow,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:      Color(0x72FFD600),
                                blurRadius: 20,
                                offset:     Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: AppColors.black, size: 24),
                        ),
                      ),
                    ],
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