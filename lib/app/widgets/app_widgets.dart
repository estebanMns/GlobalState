// lib/app/widgets/app_widgets.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/refuel_model.dart';

// ─────────────────────────────────────────────
// SHIELD BADGE
// ─────────────────────────────────────────────
class ShieldBadge extends StatelessWidget {
  final double size;
  const ShieldBadge({super.key, this.size = 52});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ShieldClipper(),
      child: Container(
        width:  size,
        height: size * 1.16,
        color:  AppColors.yellow,
        child: Center(
          child: Text('⛽', style: TextStyle(fontSize: size * 0.38)),
        ),
      ),
    );
  }
}

class _ShieldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) => Path()
    ..moveTo(s.width * .5, 0)
    ..lineTo(s.width,      s.height * .15)
    ..lineTo(s.width,      s.height * .65)
    ..lineTo(s.width * .5, s.height)
    ..lineTo(0,            s.height * .65)
    ..lineTo(0,            s.height * .15)
    ..close();

  @override
  bool shouldReclip(_) => false;
}

// ─────────────────────────────────────────────
// REFUEL CARD
// ─────────────────────────────────────────────
class RefuelCard extends StatelessWidget {
  final RefuelModel   refuel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const RefuelCard({
    super.key,
    required this.refuel,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:       onTap,
      onLongPress: onLongPress,
      child: Container(
        margin:  const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        height:  118,
        decoration: BoxDecoration(
          color:        AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border:       Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Row(
            children: [
              // ── Body ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 0, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Text('★', style: TextStyle(
                                color: AppColors.yellow, fontSize: 13)),
                            const SizedBox(width: 4),
                            Text(refuel.rating.toString(),
                                style: const TextStyle(
                                    color: AppColors.textSub, fontSize: 12)),
                          ]),
                          const SizedBox(height: 2),
                          const Text('Gasolina',
                              style: TextStyle(
                                  color:      AppColors.yellow,
                                  fontSize:   12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .3)),
                          Text(refuel.fuelType.label,
                              style: const TextStyle(
                                  color:      AppColors.white,
                                  fontSize:   16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -.2)),
                        ],
                      ),
                      Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(refuel.formattedCost,
                                  style: const TextStyle(
                                      color:      AppColors.white,
                                      fontSize:   14,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                '${refuel.liters.toStringAsFixed(0)} Litros',
                                style: const TextStyle(
                                    color: AppColors.textSub, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width:  34,
                          height: 34,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: AppColors.black, size: 16),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              // ── Image ──
              // FIX: CachedNetworkImage no tiene 'colorFilter' como param directo.
              // Se usa color + colorBlendMode para oscurecer la imagen.
              SizedBox(
                width: 130,
                child: refuel.vehicleImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl:       refuel.vehicleImageUrl!,
                        fit:            BoxFit.cover,
                        color:          Colors.black.withValues(alpha: 0.3),
                        colorBlendMode: BlendMode.darken,
                        errorWidget: (_, __, ___) => const _Placeholder(),
                        placeholder: (_, __) => Container(
                          color: AppColors.card2,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.yellow, strokeWidth: 2),
                          ),
                        ),
                      )
                    : const _Placeholder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();
  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.card2,
    child: const Center(
        child: Text('🚗', style: TextStyle(fontSize: 40))),
  );
}

// ─────────────────────────────────────────────
// SPEC CELL (grid 3×2)
// ─────────────────────────────────────────────
class SpecCell extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final bool   rightBorder;
  final bool   bottomBorder;

  const SpecCell({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.rightBorder  = true,
    this.bottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          right:  rightBorder
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
          bottom: bottomBorder
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width:  32,
            height: 32,
            decoration: BoxDecoration(
              color:        AppColors.card2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 14))),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color:      AppColors.textSub,
                  fontSize:   9,
                  letterSpacing: .8,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color:      AppColors.white,
                  fontSize:   12,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FUEL FILTER CHIP
// ─────────────────────────────────────────────
class FuelFilterChip extends StatelessWidget {
  final String       label;
  final bool         isActive;
  final VoidCallback onTap;

  const FuelFilterChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:        isActive ? AppColors.yellow : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize:   12,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.black : AppColors.textSub,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// GAUGE CIRCLE
// ─────────────────────────────────────────────
class GaugeCircle extends StatelessWidget {
  final double value;
  final String displayValue;
  final String unit;
  final String label;
  final Color  color;

  const GaugeCircle({
    super.key,
    required this.value,
    required this.displayValue,
    required this.unit,
    required this.label,
    this.color = AppColors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 90, height: 90,
          child: CustomPaint(
            painter: _GaugePainter(
                value: value.clamp(0.0, 1.0), color: color),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(displayValue,
                      style: const TextStyle(
                          fontSize:   16,
                          fontWeight: FontWeight.w900,
                          color:      AppColors.white,
                          height:     1)),
                  Text(unit,
                      style: TextStyle(
                          fontSize: 9, letterSpacing: 1, color: color)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label.toUpperCase(),
            style: const TextStyle(
                color:      AppColors.textSub,
                fontSize:   9,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color  color;
  const _GaugePainter({required this.value, required this.color});

  static const _start = -3.14159 / 2;
  static const _full  =  2 * 3.14159;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _start, _full, false,
      Paint()
        ..color      = AppColors.border
        ..style      = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap  = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _start, _full * value, false,
      Paint()
        ..color      = color
        ..style      = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap  = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.value != value;
}

// ─────────────────────────────────────────────
// BOTTOM NAV PILL
// ─────────────────────────────────────────────
class BottomNavPill extends StatelessWidget {
  final int               currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavPill({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color:        AppColors.card,
            borderRadius: BorderRadius.circular(40),
            border:       Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20,
                  offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => onTap(0),
                child: Container(
                  width:  44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.yellow, shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home_rounded,
                      color: AppColors.black, size: 22),
                ),
              ),
              const SizedBox(width: 20),
              _NavItem(
                  icon:   Icons.person_outline_rounded,
                  label:  'Perfil',
                  active: currentIndex == 1,
                  onTap:  () => onTap(1)),
              const SizedBox(width: 20),
              _NavItem(
                  icon:   Icons.bar_chart_rounded,
                  label:  'Stats',
                  active: currentIndex == 2,
                  onTap:  () => onTap(2)),
              const SizedBox(width: 20),
              _NavItem(
                  icon:   Icons.settings_outlined,
                  label:  'Config',
                  active: currentIndex == 3,
                  onTap:  () => onTap(3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final bool         active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: active ? AppColors.yellow : AppColors.textSub,
            size: 22),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
              fontSize:    8,
              letterSpacing: 1.5,
              color: active ? AppColors.yellow : AppColors.textSub,
            )),
      ],
    ),
  );
}