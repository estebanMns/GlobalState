// lib/app/routes/app_routes.dart
import 'package:get/get.dart';
import '../bindings/home_binding.dart';
import '../bindings/stats_binding.dart';
import '../views/splash_view.dart';
import '../views/home_view.dart';
import '../views/add_refuel_view.dart';
import '../views/stats_view.dart';

abstract class Routes {
  static const SPLASH     = '/';
  static const HOME       = '/home';
  static const ADD_REFUEL = '/add-refuel';
  static const STATS      = '/stats';
}

final appPages = [
  GetPage(
    name: Routes.SPLASH,
    page: () => const SplashView(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: Routes.HOME,
    page: () => const HomeView(),
    binding: HomeBinding(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: Routes.ADD_REFUEL,
    page: () => const AddRefuelView(),
    transition: Transition.downToUp,
    transitionDuration: const Duration(milliseconds: 300),
  ),
  GetPage(
    name: Routes.STATS,
    page: () => const StatsView(),
    binding: StatsBinding(),
    transition: Transition.rightToLeft,
  ),
];