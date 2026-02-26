// lib/app/views/add_refuel_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/refuel_controller.dart';
import '../models/refuel_model.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class AddRefuelView extends GetView<RefuelController> {
  const AddRefuelView({super.key});

  static const _ferrariUrl =
      'https://w0.peakpx.com/wallpaper/887/313/HD-wallpaper-ferrari-lines-car-ferrari-458-ferrari-488-ferrari-f12-ferrari-hybrid-ferrari-sf90-hybrid-ferrari-laferrari-red-thumbnail.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildCarStage(),
            _buildCarNameRow(),
            _buildSpecsGrid(),
            _buildFuelTypeChips(),
            _buildInputs(),
            _buildTotalPreview(),
            const SizedBox(height: 16),
            _buildSaveButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Car stage ─────────────────────────────────────────────────
  Widget _buildCarStage() {
    return SizedBox(
      height: 240,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // FIX: usar color + colorBlendMode en lugar de colorFilter
          CachedNetworkImage(
            imageUrl:       _ferrariUrl,
            fit:            BoxFit.cover,
            alignment:      const Alignment(0, .3),
            color:          Colors.black.withValues(alpha: 0.5),
            colorBlendMode: BlendMode.darken,
            errorWidget: (_, __, ___) =>
                Container(color: AppColors.card),
            placeholder: (_, __) =>
                Container(color: AppColors.black),
          ),
          // Gradient to black
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin:  Alignment.topCenter,
                end:    Alignment.bottomCenter,
                stops:  [0.2, 0.85, 1.0],
                colors: [
                  Colors.transparent,
                  Color(0xE6000000),
                  AppColors.black,
                ],
              ),
            ),
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      width:  38,
                      height: 38,
                      decoration: BoxDecoration(
                        color:        Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: AppColors.white, size: 16),
                    ),
                  ),
                  const ShieldBadge(size: 36),
                  Container(
                    width:  38,
                    height: 38,
                    decoration: BoxDecoration(
                      color:        Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Icon(Icons.calendar_today_outlined,
                        color: AppColors.white, size: 16),
                  ),
                ],
              ),
            ),
          ),
          // Nav arrows
          Positioned(
            bottom: 14, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _navBtn(Icons.chevron_left),
                const SizedBox(width: 6),
                _navBtn(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon) => Container(
    width:  30,
    height: 30,
    decoration: BoxDecoration(
      color:        AppColors.card2,
      borderRadius: BorderRadius.circular(8),
      border:       Border.all(color: AppColors.border),
    ),
    child: Icon(icon, color: AppColors.textSub, size: 16),
  );

  // ── Car name + rating ─────────────────────────────────────────
  Widget _buildCarNameRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Ferrari Amalfi · Extra',
            style: TextStyle(
              fontSize:     20,
              fontWeight:   FontWeight.w800,
              color:        AppColors.white,
              letterSpacing: -.3,
            ),
          ),
          Row(children: const [
            Text('★',
                style: TextStyle(color: AppColors.yellow, fontSize: 14)),
            SizedBox(width: 4),
            Text('4.9',
                style: TextStyle(
                    color:      AppColors.white,
                    fontSize:   14,
                    fontWeight: FontWeight.w600)),
          ]),
        ],
      ),
    );
  }

  // ── Specs 3×2 ─────────────────────────────────────────────────
  Widget _buildSpecsGrid() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      decoration: BoxDecoration(
        color:        AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border:       Border.all(color: AppColors.border),
      ),
      child: Obx(() => Column(children: [
        Row(children: [
          Expanded(child: SpecCell(
            icon: '🏎️', label: 'Rendimiento',
            value: '${controller.averageEfficiency.toStringAsFixed(1)} km/L',
            rightBorder: true, bottomBorder: true,
          )),
          Expanded(child: SpecCell(
            icon: '⚙️', label: 'Motor',
            value: '2.0 Turbo',
            rightBorder: true, bottomBorder: true,
          )),
          Expanded(child: SpecCell(
            icon: '📏', label: 'Km Recorridos',
            value: '${controller.totalKilometers.toStringAsFixed(0)} km',
            rightBorder: false, bottomBorder: true,
          )),
        ]),
        Row(children: [
          Expanded(child: SpecCell(
            icon: '🛡️', label: 'Airbag',
            value: '4',
            rightBorder: true, bottomBorder: false,
          )),
          Expanded(child: SpecCell(
            icon: '⛽', label: 'Tipo Fuel',
            value: controller.selectedType.value.shortLabel,
            rightBorder: true, bottomBorder: false,
          )),
          Expanded(child: SpecCell(
            icon: '🛞', label: 'Tracción',
            value: 'RWD',
            rightBorder: false, bottomBorder: false,
          )),
        ]),
      ])),
    );
  }

  // ── Fuel type chips ───────────────────────────────────────────
  Widget _buildFuelTypeChips() {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        itemCount: FuelType.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (_, i) {
          final t = FuelType.values[i];
          return Obx(() {
            final isActive = controller.selectedType.value == t;
            return GestureDetector(
              onTap: () => controller.selectFuelType(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  // FIX: .withValues en lugar de .withOpacity
                  color: isActive
                      ? AppColors.yellow.withValues(alpha: 0.12)
                      : AppColors.card2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? AppColors.yellow
                        : AppColors.border,
                  ),
                ),
                child: Column(children: [
                  Text(
                    t.shortLabel,
                    style: TextStyle(
                      fontSize:   13,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? AppColors.yellow
                          : AppColors.white,
                    ),
                  ),
                  Text(
                    '\$${t.defaultPrice.toStringAsFixed(0)}/L',
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSub),
                  ),
                ]),
              ),
            );
          });
        },
      ),
    );
  }

  // ── Inputs ────────────────────────────────────────────────────
  Widget _buildInputs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(children: [
        _InputField(
          label:     'LITROS CARGADOS',
          unit:      'L',
          onChanged: (v) =>
              controller.formLiters.value = double.tryParse(v) ?? 0,
        ),
        const SizedBox(height: 12),
        Obx(() => _InputField(
          label:        'PRECIO POR LITRO',
          unit:         'COP',
          initialValue: controller.selectedType.value
              .defaultPrice
              .toStringAsFixed(0),
          onChanged: (v) =>
              controller.formPricePerLiter.value =
                  double.tryParse(v) ?? 0,
        )),
        const SizedBox(height: 12),
        _InputField(
          label:     'ODÓMETRO ACTUAL',
          unit:      'km',
          onChanged: (v) =>
              controller.formOdometer.value = double.tryParse(v) ?? 0,
        ),
      ]),
    );
  }

  // ── Total preview ─────────────────────────────────────────────
  Widget _buildTotalPreview() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1200), Color(0xFF141414)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        // FIX: .withValues en lugar de .withOpacity
        border: Border.all(
            color: AppColors.yellow.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color:      AppColors.yellow.withValues(alpha: 0.08),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL A PAGAR',
                style: TextStyle(
                  fontSize:     9,
                  fontWeight:   FontWeight.w600,
                  color:        AppColors.textSub,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 6),
              Obx(() => Text(
                '\$${_fmt(controller.formTotalCost)}',
                style: const TextStyle(
                  fontSize:   28,
                  fontWeight: FontWeight.w900,
                  color:      AppColors.yellow,
                ),
              )),
              const SizedBox(height: 4),
              Obx(() => Text(
                '${controller.formLiters.value.toStringAsFixed(0)}L'
                ' × \$${controller.formPricePerLiter.value.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textDim),
              )),
            ],
          ),
          const Text('⛽',
              style: TextStyle(
                  fontSize: 42, color: Color(0x66FFFFFF))),
        ],
      ),
    );
  }

  // ── Save button ───────────────────────────────────────────────
  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width:  double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: controller.addRefuel,
          child: const Text('GUARDAR RECARGA'),
        ),
      ),
    );
  }

  String _fmt(double val) {
    final s   = val.toStringAsFixed(0);
    final buf = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buf.write(',');
      buf.write(s[i]);
      count++;
    }
    return buf.toString().split('').reversed.join();
  }
}

// ─────────────────────────────────────────────
// Input field widget
// ─────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final String            label;
  final String            unit;
  final String?           initialValue;
  final ValueChanged<String> onChanged;

  const _InputField({
    required this.label,
    required this.unit,
    this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize:     9,
              fontWeight:   FontWeight.w600,
              color:        AppColors.textSub,
              letterSpacing: 2.5,
            )),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color:        AppColors.card2,
            borderRadius: BorderRadius.circular(14),
            border:       Border.all(color: AppColors.border),
          ),
          child: Row(children: [
            Expanded(
              child: TextFormField(
                initialValue: initialValue,
                onChanged:    onChanged,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[\d.]')),
                ],
                style: const TextStyle(
                  fontSize:   22,
                  fontWeight: FontWeight.w700,
                  color:      AppColors.white,
                ),
                decoration: const InputDecoration(
                  border:          InputBorder.none,
                  enabledBorder:   InputBorder.none,
                  focusedBorder:   InputBorder.none,
                  filled:          false,
                  contentPadding:  EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  hintText:  '0',
                  hintStyle: TextStyle(
                      color: AppColors.textDim, fontSize: 22),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(unit,
                  style: const TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w700,
                    color:      AppColors.yellow,
                  )),
            ),
          ]),
        ),
      ],
    );
  }
}