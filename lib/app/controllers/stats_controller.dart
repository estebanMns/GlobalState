// lib/app/controllers/stats_controller.dart
import 'package:get/get.dart';
import '../models/refuel_model.dart';
import 'refuel_controller.dart';

class MonthlyData {
  final String month;
  final int    year;
  final double totalSpent;
  final double totalLiters;
  final int    refuelCount;
  final bool   isCurrentMonth;

  const MonthlyData({
    required this.month,
    required this.year,
    required this.totalSpent,
    required this.totalLiters,
    required this.refuelCount,
    required this.isCurrentMonth,
  });
}

class StatsController extends GetxController {

  final RefuelController _ref = Get.find<RefuelController>();

  // ── Estado ─────────────────────────────────
  final RxString selectedPeriod = 'mes'.obs; // 'semana' | 'mes' | 'año'

  // ── Filtered list ─────────────────────────
  List<RefuelModel> get refuelsByPeriod {
    final now = DateTime.now();
    return _ref.refuels.where((r) {
      switch (selectedPeriod.value) {
        case 'semana':
          return r.date.isAfter(now.subtract(const Duration(days: 7)));
        case 'mes':
          return r.date.month == now.month && r.date.year == now.year;
        case 'año':
          return r.date.year == now.year;
        default: return true;
      }
    }).toList();
  }

  // ── Métricas ──────────────────────────────
  double get totalSpentByPeriod =>
      refuelsByPeriod.fold(0.0, (s, r) => s + r.totalCost);

  double get totalLitersByPeriod =>
      refuelsByPeriod.fold(0.0, (s, r) => s + r.liters);

  int get refuelCountByPeriod => refuelsByPeriod.length;

  double get averageEfficiency {
    final list = _ref.refuels.toList()
      ..sort((a, b) => a.odometer.compareTo(b.odometer));
    if (list.length < 2) return 0.0;
    final km = list.last.odometer - list.first.odometer;
    final lt = list.skip(1).fold(0.0, (s, r) => s + r.liters);
    return lt > 0 ? km / lt : 0.0;
  }

  double get totalKilometers {
    final list = _ref.refuels.toList()
      ..sort((a, b) => a.odometer.compareTo(b.odometer));
    if (list.length < 2) return 0.0;
    return list.last.odometer - list.first.odometer;
  }

  double get spendingChangePercent {
    final now = DateTime.now();
    final prev = DateTime(now.year, now.month - 1);
    final thisMonth = _ref.refuels
        .where((r) => r.date.month == now.month  && r.date.year == now.year)
        .fold(0.0, (s, r) => s + r.totalCost);
    final lastMonth = _ref.refuels
        .where((r) => r.date.month == prev.month && r.date.year == prev.year)
        .fold(0.0, (s, r) => s + r.totalCost);
    if (lastMonth == 0) return 0.0;
    return ((thisMonth - lastMonth) / lastMonth) * 100;
  }

  String get spendingTrend {
    final c = spendingChangePercent;
    if (c > 5)  return 'up';
    if (c < -5) return 'down';
    return 'stable';
  }

  RefuelModel? get bestEfficiencyRefuel {
    final sorted = _ref.refuels.toList()
      ..sort((a, b) => a.odometer.compareTo(b.odometer));
    if (sorted.length < 2) return null;
    RefuelModel? best;
    double bestEff = 0;
    for (int i = 1; i < sorted.length; i++) {
      final km = sorted[i].odometer - sorted[i - 1].odometer;
      final lt = sorted[i].liters;
      if (lt > 0 && km / lt > bestEff) {
        bestEff = km / lt;
        best    = sorted[i];
      }
    }
    return best;
  }

  // ── Gráfica de barras ─────────────────────
  List<MonthlyData> get last6MonthsData {
    const names = ['ENE','FEB','MAR','ABR','MAY','JUN',
                   'JUL','AGO','SEP','OCT','NOV','DIC'];
    final now = DateTime.now();
    return List.generate(6, (i) {
      final offset = 5 - i;
      final target = DateTime(now.year, now.month - offset, 1);
      final list   = _ref.refuels.where((r) =>
          r.date.month == target.month && r.date.year == target.year).toList();
      return MonthlyData(
        month:          names[target.month - 1],
        year:           target.year,
        totalSpent:     list.fold(0.0, (s, r) => s + r.totalCost),
        totalLiters:    list.fold(0.0, (s, r) => s + r.liters),
        refuelCount:    list.length,
        isCurrentMonth: i == 5,
      );
    });
  }

  double get maxMonthlySpent {
    final data = last6MonthsData;
    if (data.isEmpty) return 1;
    return data.map((d) => d.totalSpent).reduce((a, b) => a > b ? a : b);
  }

  // ── Acciones ─────────────────────────────
  void changePeriod(String p) => selectedPeriod.value = p;

  // ── Lifecycle ─────────────────────────────
  @override
  void onInit() {
    super.onInit();
    ever(_ref.refuels, (_) => selectedPeriod.refresh());
  }
}