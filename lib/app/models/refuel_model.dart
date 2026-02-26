// lib/app/models/refuel_model.dart

enum FuelType { corriente, extra, diesel }

extension FuelTypeExtension on FuelType {
  String get label {
    switch (this) {
      case FuelType.corriente: return 'Corriente 87';
      case FuelType.extra:     return 'Extra 95';
      case FuelType.diesel:    return 'Diésel';
    }
  }

  String get shortLabel {
    switch (this) {
      case FuelType.corriente: return 'Corriente';
      case FuelType.extra:     return 'Extra';
      case FuelType.diesel:    return 'Diésel';
    }
  }

  double get defaultPrice {
    switch (this) {
      case FuelType.corriente: return 9800;
      case FuelType.extra:     return 10200;
      case FuelType.diesel:    return 9500;
    }
  }
}

class RefuelModel {
  final String   id;
  final double   liters;
  final double   pricePerLiter;
  final double   odometer;
  final DateTime date;
  final FuelType fuelType;
  final String?  vehicleImageUrl; // URL de imagen del vehículo

  const RefuelModel({
    required this.id,
    required this.liters,
    required this.pricePerLiter,
    required this.odometer,
    required this.date,
    required this.fuelType,
    this.vehicleImageUrl,
  });

  // ── Computed ────────────────────────────────
  double get totalCost => liters * pricePerLiter;

  String get formattedCost {
    final val = totalCost.toStringAsFixed(0);
    final result = StringBuffer();
    int count = 0;
    for (int i = val.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result.write(',');
      result.write(val[i]);
      count++;
    }
    return '\$${result.toString().split('').reversed.join()}';
  }

  String get formattedDate {
    const months = ['Ene','Feb','Mar','Abr','May','Jun',
                    'Jul','Ago','Sep','Oct','Nov','Dic'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  double get rating {
    // Rating ficticio basado en tipo de combustible
    switch (fuelType) {
      case FuelType.extra:     return 4.9;
      case FuelType.corriente: return 4.7;
      case FuelType.diesel:    return 3.5;
    }
  }

  // ── Serialización ───────────────────────────
  Map<String, dynamic> toJson() => {
    'id':             id,
    'liters':         liters,
    'pricePerLiter':  pricePerLiter,
    'odometer':       odometer,
    'date':           date.toIso8601String(),
    'fuelType':       fuelType.index,
    'vehicleImageUrl': vehicleImageUrl,
  };

  factory RefuelModel.fromJson(Map<String, dynamic> json) => RefuelModel(
    id:            json['id'],
    liters:        (json['liters'] as num).toDouble(),
    pricePerLiter: (json['pricePerLiter'] as num).toDouble(),
    odometer:      (json['odometer'] as num).toDouble(),
    date:          DateTime.parse(json['date']),
    fuelType:      FuelType.values[json['fuelType'] as int],
    vehicleImageUrl: json['vehicleImageUrl'],
  );

  RefuelModel copyWith({
    String?   id,
    double?   liters,
    double?   pricePerLiter,
    double?   odometer,
    DateTime? date,
    FuelType? fuelType,
    String?   vehicleImageUrl,
  }) => RefuelModel(
    id:             id             ?? this.id,
    liters:         liters         ?? this.liters,
    pricePerLiter:  pricePerLiter  ?? this.pricePerLiter,
    odometer:       odometer       ?? this.odometer,
    date:           date           ?? this.date,
    fuelType:       fuelType       ?? this.fuelType,
    vehicleImageUrl: vehicleImageUrl ?? this.vehicleImageUrl,
  );
}