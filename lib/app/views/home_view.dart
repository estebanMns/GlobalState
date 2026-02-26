// lib/app/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/refuel_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';
import '../routes/app_routes.dart';

class HomeView extends GetView<RefuelController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    )
                  : _buildContent()),
            ),
            // Bottom nav
            BottomNavPill(
              currentIndex: 0,
              onTap: (i) {
                if (i == 2) Get.toNamed(Routes.STATS);
              },
            ),
          ],
        ),
      ),
      // FAB para agregar recarga
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.ADD_REFUEL),
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Greeting ──
        SliverToBoxAdapter(child: _buildGreeting()),

        // ── Search bar ──
        SliverToBoxAdapter(child: _buildSearchBar()),

        // ── Filter chips ──
        SliverToBoxAdapter(child: _buildFilters()),

        // ── Section title ──
        SliverToBoxAdapter(child: _buildSectionHeader()),

        // ── Refuel cards list ──
        Obx(() {
          final list = controller.filteredRefuels;
          if (list.isEmpty) {
            return const SliverToBoxAdapter(child: _EmptyState());
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => RefuelCard(
                refuel: list[i],
                onTap: () => Get.toNamed(Routes.ADD_REFUEL),
                onLongPress: () => _confirmDelete(list[i].id),
              ),
              childCount: list.length,
            ),
          );
        }),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  // ── Greeting row ─────────────────────────────────────────────
  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/80?img=11',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.card2,
                  child: const Icon(Icons.person, color: AppColors.textSub),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hola, Carlos',
                  style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSub),
                    SizedBox(width: 2),
                    Text(
                      'Neiva, Huila ▾',
                      style: TextStyle(fontSize: 12, color: AppColors.textSub),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Notification bell
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.textSub, size: 20),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    width: 7, height: 7,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.black, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar ───────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textSub, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Buscar recarga o vehículo...',
              style: const TextStyle(color: AppColors.textDim, fontSize: 14),
            ),
          ),
          Container(
            width: 26, height: 26,
            decoration: BoxDecoration(
              color: AppColors.card2,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 13, color: AppColors.textSub),
          ),
        ],
      ),
    );
  }

  // ── Filter chips ─────────────────────────────────────────────
  Widget _buildFilters() {
    final filters = ['Todas', 'Extra 95', 'Corriente', 'Diésel'];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => Obx(() => FuelFilterChip(
          label:    filters[i],
          isActive: controller.activeFilter.value == filters[i],
          onTap:    () => controller.setFilter(filters[i]),
        )),
      ),
    );
  }

  // ── Section header ───────────────────────────────────────────
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recientes',
            style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800,
              color: AppColors.white, letterSpacing: -.3,
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.STATS),
            child: const Text(
              'Ver Todas',
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: AppColors.yellow,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Delete confirm ───────────────────────────────────────────
  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: 'Eliminar',
      middleText: '¿Deseas eliminar esta recarga?',
      backgroundColor: AppColors.card,
      titleStyle: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w700),
      middleTextStyle: const TextStyle(color: AppColors.textSub),
      textCancel: 'Cancelar',
      textConfirm: 'Eliminar',
      confirmTextColor: AppColors.black,
      buttonColor: AppColors.yellow,
      cancelTextColor: AppColors.textSub,
      onConfirm: () {
        controller.deleteRefuel(id);
        Get.back();
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Text('⛽', style: TextStyle(fontSize: 56)),
          SizedBox(height: 16),
          Text(
            'Sin recargas registradas',
            style: TextStyle(color: AppColors.textSub, fontSize: 15),
          ),
          SizedBox(height: 6),
          Text(
            'Presiona + para agregar tu primera recarga',
            style: TextStyle(color: AppColors.textDim, fontSize: 13),
          ),
        ],
      ),
    );
  }
}