// lib/app/views/stats_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/stats_controller.dart';
import '../models/refuel_model.dart'; // FIX: necesario para FuelType.label extension
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class StatsView extends GetView<StatsController> {
  const StatsView({super.key});

  static const _ferrariUrl =
      'https://w0.peakpx.com/wallpaper/887/313/HD-wallpaper-ferrari-lines-car-ferrari-458-ferrari-488-ferrari-f12-ferrari-hybrid-ferrari-sf90-hybrid-ferrari-laferrari-red-thumbnail.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(children: [
                  _buildHero(),
                  _buildPeriodSelector(),
                  const SizedBox(height: 4),
                  _buildBigCard(),
                  const SizedBox(height: 14),
                  _buildBarChart(),
                  const SizedBox(height: 14),
                  _buildMetricsGrid(),
                  const SizedBox(height: 14),
                  _buildTrophyCard(),
                  const SizedBox(height: 24),
                ]),
              )),
            ),
            BottomNavPill(currentIndex: 2, onTap: (_) => Get.back()),
          ],
        ),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────
  Widget _buildHero() {
    return SizedBox(
      height: 180,
      child: Stack(fit: StackFit.expand, children: [
        // FIX: color + colorBlendMode en lugar de colorFilter
        CachedNetworkImage(
          imageUrl:       _ferrariUrl,
          fit:            BoxFit.cover,
          alignment:      const Alignment(0, .5),
          color:          Colors.black.withValues(alpha: 0.65),
          colorBlendMode: BlendMode.darken,
          errorWidget: (_, __, ___) =>
              Container(color: AppColors.card),
          placeholder: (_, __) =>
              Container(color: AppColors.black),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin:  Alignment.topCenter,
              end:    Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.black],
            ),
          ),
        ),
        Positioned(
          top: 14, left: 20, right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Estadísticas',
                    style: TextStyle(
                        fontSize:     24,
                        fontWeight:   FontWeight.w800,
                        color:        AppColors.white,
                        letterSpacing: -.3)),
                SizedBox(height: 3),
                Text('FEBRERO 2026 · RESUMEN',
                    style: TextStyle(
                        fontSize:  10,
                        letterSpacing: 2,
                        color: AppColors.textSub)),
              ]),
              const ShieldBadge(size: 36),
            ],
          ),
        ),
      ]),
    );
  }

  // ── Period selector ───────────────────────────────────────────
  Widget _buildPeriodSelector() {
    const periods = ['semana', 'mes', 'año'];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        itemCount: periods.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final p = periods[i];
          return Obx(() {
            final active = controller.selectedPeriod.value == p;
            return GestureDetector(
              onTap: () => controller.changePeriod(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  // FIX: .withValues en lugar de .withOpacity
                  color: active
                      ? AppColors.yellow.withValues(alpha: 0.1)
                      : AppColors.card2,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: active
                        ? AppColors.yellow
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  p.toUpperCase(),
                  style: TextStyle(
                    fontSize:     10,
                    fontWeight:   FontWeight.w700,
                    letterSpacing: 2,
                    color: active
                        ? AppColors.yellow
                        : AppColors.textSub,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // ── Big spend card ─────────────────────────────────────────────
  Widget _buildBigCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1200), Color(0xFF141414)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        // FIX: .withValues en lugar de .withOpacity
        border: Border.all(
            color: AppColors.yellow.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
              color:      AppColors.yellow.withValues(alpha: 0.06),
              blurRadius: 28),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('GASTO TOTAL',
                style: TextStyle(
                  fontSize:     9,
                  fontWeight:   FontWeight.w600,
                  color:        AppColors.textSub,
                  letterSpacing: 2.5,
                )),
            const SizedBox(height: 6),
            Text(
              '\$${_fmt(controller.totalSpentByPeriod)}',
              style: const TextStyle(
                fontSize:   32,
                fontWeight: FontWeight.w900,
                color:      AppColors.yellow,
                height:     1,
              ),
            ),
            const SizedBox(height: 4),
            const Text('pesos colombianos',
                style: TextStyle(
                    fontSize: 11, color: AppColors.textDim)),
            const SizedBox(height: 10),
            _trendBadge(),
          ]),
          const Text('⛽',
              style: TextStyle(
                  fontSize: 52, color: Color(0x14FFFFFF))),
        ],
      ),
    );
  }

  Widget _trendBadge() {
    final c    = controller.spendingChangePercent;
    final t    = controller.spendingTrend;
    final isUp = t == 'up';
    final color = isUp
        ? const Color(0xFFF87171)
        : const Color(0xFF52E37A);
    final bg = isUp
        ? const Color(0x26F87171)
        : const Color(0x2652E37A);
    final label = t == 'stable'
        ? '= Sin cambios'
        : '${isUp ? '↑' : '↓'} ${c.abs().toStringAsFixed(1)}% vs anterior';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: TextStyle(
              fontSize:   10,
              fontWeight: FontWeight.w700,
              color:      color)),
    );
  }

  // ── Bar chart ─────────────────────────────────────────────────
  Widget _buildBarChart() {
    final data   = controller.last6MonthsData;
    final maxVal = controller.maxMonthlySpent;

    return Container(
      margin:  const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color:        AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('GASTO MENSUAL — 6 MESES',
              style: TextStyle(
                fontSize:     11,
                fontWeight:   FontWeight.w700,
                color:        AppColors.white,
                letterSpacing: 2,
              )),
          const SizedBox(height: 16),
          SizedBox(
            height: 88,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((d) {
                final factor = maxVal > 0 ? d.totalSpent / maxVal : 0.0;
                final barH   = 6.0 + factor * 82;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (d.isCurrentMonth && d.totalSpent > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '\$${_fmtShort(d.totalSpent)}',
                              style: const TextStyle(
                                  fontSize:   9,
                                  fontWeight: FontWeight.w700,
                                  color:      AppColors.yellow),
                            ),
                          ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 700),
                          curve:    Curves.easeOut,
                          height:   barH,
                          decoration: BoxDecoration(
                            gradient: d.isCurrentMonth
                                ? const LinearGradient(
                                    begin:  Alignment.topCenter,
                                    end:    Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFFFE033),
                                      AppColors.yellow,
                                    ],
                                  )
                                : null,
                            color: d.isCurrentMonth
                                ? null
                                : AppColors.card2,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(5)),
                            boxShadow: d.isCurrentMonth
                                ? const [BoxShadow(
                                    color:      Color(0x55FFD600),
                                    blurRadius: 8)]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(d.month,
                            style: TextStyle(
                              fontSize:   9,
                              letterSpacing: 1,
                              color: d.isCurrentMonth
                                  ? AppColors.yellow
                                  : AppColors.textDim,
                              fontWeight: d.isCurrentMonth
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Metrics 2×2 ───────────────────────────────────────────────
  Widget _buildMetricsGrid() {
    final metrics = [
      {
        'ico': '🏎️',
        'val': '${controller.averageEfficiency.toStringAsFixed(1)} km/L',
        'lbl': 'Rendimiento',
      },
      {
        'ico': '📏',
        'val': '${controller.totalKilometers.toStringAsFixed(0)} km',
        'lbl': 'Recorridos',
      },
      {
        'ico': '🧪',
        'val': '${controller.totalLitersByPeriod.toStringAsFixed(0)} L',
        'lbl': 'Litros',
      },
      {
        'ico': '🔁',
        'val': '${controller.refuelCountByPeriod} cargas',
        'lbl': 'Recargas',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount:  2,
        crossAxisSpacing: 10,
        mainAxisSpacing:  10,
        shrinkWrap:       true,
        physics:          const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.5,
        children: metrics
            .map((m) => Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:        AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border:       Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(m['ico']!,
                          style: const TextStyle(fontSize: 22)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['val']!,
                              style: const TextStyle(
                                  fontSize:   16,
                                  fontWeight: FontWeight.w800,
                                  color:      AppColors.white)),
                          Text(m['lbl']!.toUpperCase(),
                              style: const TextStyle(
                                color:        AppColors.textSub,
                                fontSize:     9,
                                letterSpacing: 1.5,
                                fontWeight:   FontWeight.w600,
                              )),
                        ],
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ── Trophy card ───────────────────────────────────────────────
  Widget _buildTrophyCard() {
    final best = controller.bestEfficiencyRefuel;
    if (best == null) return const SizedBox.shrink();

    return Container(
      margin:  const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Container(
          width:  44,
          height: 44,
          decoration: BoxDecoration(
            color:        const Color(0x2052E37A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x4052E37A)),
          ),
          child: const Center(
              child: Text('🏆', style: TextStyle(fontSize: 20))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('MEJOR RECARGA DEL MES',
                  style: TextStyle(
                    fontSize:     9,
                    fontWeight:   FontWeight.w600,
                    color:        AppColors.textSub,
                    letterSpacing: 2,
                  )),
              const SizedBox(height: 3),
              // FIX: importar refuel_model.dart para tener acceso a .label
              Text(
                '${best.fuelType.label} — ${best.liters.toStringAsFixed(0)}L',
                style: const TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w700,
                    color:      AppColors.white),
              ),
              Text(
                '${best.formattedDate} · ${best.odometer.toStringAsFixed(0)} km',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSub),
              ),
            ],
          ),
        ),
        Text(best.formattedCost,
            style: const TextStyle(
              fontSize:   14,
              fontWeight: FontWeight.w700,
              color:      AppColors.yellow,
            )),
      ]),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────
  String _fmt(double v) {
    final s   = v.toStringAsFixed(0);
    final buf = StringBuffer();
    int c = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (c > 0 && c % 3 == 0) buf.write(',');
      buf.write(s[i]);
      c++;
    }
    return buf.toString().split('').reversed.join();
  }

  String _fmtShort(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000)    return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }
}