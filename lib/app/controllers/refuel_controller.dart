// lib/app/controllers/refuel_controller.dart
import 'package:flutter/material.dart' show Color, EdgeInsets;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/refuel_model.dart';

class RefuelController extends GetxController {

  final _box = GetStorage();
  static const _storageKey = 'refuels';

  // ── Observables ────────────────────────────
  final RxList<RefuelModel> refuels          = <RefuelModel>[].obs;
  final RxBool              isLoading        = false.obs;
  final Rx<FuelType>        selectedType     = FuelType.extra.obs;
  final RxString            activeFilter     = 'Todas'.obs;

  // Form fields
  final RxDouble formLiters        = 0.0.obs;
  final RxDouble formPricePerLiter = 0.0.obs;
  final RxDouble formOdometer      = 0.0.obs;

  // ── Computed ───────────────────────────────

  double get totalSpentThisMonth {
    final now = DateTime.now();
    return refuels
        .where((r) => r.date.month == now.month && r.date.year == now.year)
        .fold(0.0, (s, r) => s + r.totalCost);
  }

  double get averageEfficiency {
    if (refuels.length < 2) return 0.0;
    final sorted = refuels.toList()
      ..sort((a, b) => a.odometer.compareTo(b.odometer));
    final km     = sorted.last.odometer - sorted.first.odometer;
    final liters = sorted.skip(1).fold(0.0, (s, r) => s + r.liters);
    return liters > 0 ? km / liters : 0.0;
  }

  int get countThisMonth {
    final now = DateTime.now();
    return refuels
        .where((r) => r.date.month == now.month && r.date.year == now.year)
        .length;
  }

  double get totalKilometers {
    if (refuels.length < 2) return 0.0;
    final sorted = refuels.toList()
      ..sort((a, b) => a.odometer.compareTo(b.odometer));
    return sorted.last.odometer - sorted.first.odometer;
  }

  double get formTotalCost => formLiters.value * formPricePerLiter.value;

  List<RefuelModel> get filteredRefuels {
    if (activeFilter.value == 'Todas') return refuels.toList();
    return refuels.where((r) {
      switch (activeFilter.value) {
        case 'Extra 95':  return r.fuelType == FuelType.extra;
        case 'Corriente': return r.fuelType == FuelType.corriente;
        case 'Diésel':    return r.fuelType == FuelType.diesel;
        default:          return true;
      }
    }).toList();
  }

  // ── Lifecycle ──────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  // ── Storage ────────────────────────────────

  void _loadFromStorage() {
    isLoading.value = true;
    try {
      final raw = _box.read<List>(_storageKey);
      if (raw != null) {
        refuels.assignAll(
          raw.map((e) => RefuelModel.fromJson(
              Map<String, dynamic>.from(e as Map))),
        );
      } else {
        _loadSampleData();
      }
    } catch (_) {
      _loadSampleData();
    } finally {
      isLoading.value = false;
    }
  }

  void _saveToStorage() {
    _box.write(_storageKey, refuels.map((r) => r.toJson()).toList());
  }

  void _loadSampleData() {
    const ferrariImg =
        'https://w0.peakpx.com/wallpaper/887/313/HD-wallpaper-ferrari-lines-car-ferrari-458-ferrari-488-ferrari-f12-ferrari-hybrid-ferrari-sf90-hybrid-ferrari-laferrari-red-thumbnail.jpg';

    refuels.assignAll([
      RefuelModel(
        id: const Uuid().v4(),
        liters: 35, pricePerLiter: 10200, odometer: 121050,
        date: DateTime.now().subtract(const Duration(days: 5)),
        fuelType: FuelType.extra,
        vehicleImageUrl: ferrariImg,
      ),
      RefuelModel(
        id: const Uuid().v4(),
        liters: 40, pricePerLiter: 9800, odometer: 120500,
        date: DateTime.now().subtract(const Duration(days: 15)),
        fuelType: FuelType.corriente,
        vehicleImageUrl:
            'https://w0.peakpx.com/wallpaper/887/313/HD-wallpaper-ferrari-lines-car-ferrari-458-ferrari-488-ferrari-f12-ferrari-hybrid-ferrari-sf90-hybrid-ferrari-laferrari-red-thumbnail.jpg',
      ),
      RefuelModel(
        id: const Uuid().v4(),
        liters: 30, pricePerLiter: 9500, odometer: 119800,
        date: DateTime.now().subtract(const Duration(days: 28)),
        fuelType: FuelType.diesel,
        vehicleImageUrl:
            'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=400',
      ),
    ]);
  }

  // ── Actions ────────────────────────────────

  void selectFuelType(FuelType type) {
    selectedType.value      = type;
    formPricePerLiter.value = type.defaultPrice;
  }

  void setFilter(String filter) => activeFilter.value = filter;

  void addRefuel() {
    if (formLiters.value <= 0) {
      _snack('⚠️ Litros requeridos', 'Ingresa los litros cargados');
      return;
    }
    if (formPricePerLiter.value <= 0) {
      _snack('⚠️ Precio requerido', 'Ingresa el precio por litro');
      return;
    }
    if (formOdometer.value <= 0) {
      _snack('⚠️ Odómetro requerido', 'Ingresa el odómetro actual');
      return;
    }

    const ferrariImg =
        'https://cdn.ferrari.com/cms/network/media/img/resize/'
        '685e9f389f42e90021e22970-ferrari-amalfi-social-card-intro?width=1080';

    final newRefuel = RefuelModel(
      id:             const Uuid().v4(),
      liters:         formLiters.value,
      pricePerLiter:  formPricePerLiter.value,
      odometer:       formOdometer.value,
      date:           DateTime.now(),
      fuelType:       selectedType.value,
      vehicleImageUrl: ferrariImg,
    );

    refuels.insert(0, newRefuel);
    _saveToStorage();
    _resetForm();
    Get.back();

    Get.snackbar(
      '✅ Recarga guardada',
      '${newRefuel.liters}L · ${newRefuel.formattedCost}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1C1C1C),
      colorText: const Color(0xFFFFD600),
      borderRadius: 14,
      margin: const EdgeInsets.all(16),
    );
  }

  void deleteRefuel(String id) {
    refuels.removeWhere((r) => r.id == id);
    _saveToStorage();
    _snack('Eliminado', 'Recarga eliminada', isWarning: false);
  }

  void _snack(String title, String msg, {bool isWarning = true}) {
    Get.snackbar(
      title, msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1C1C1C),
      colorText: isWarning
          ? const Color(0xFFFFFFFF)
          : const Color(0xFF888888),
      borderRadius: 14,
      margin: const EdgeInsets.all(16),
    );
  }

  void _resetForm() {
    formLiters.value        = 0.0;
    formPricePerLiter.value = 0.0;
    formOdometer.value      = 0.0;
    selectedType.value      = FuelType.extra;
  }
}