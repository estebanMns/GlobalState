// lib/app/bindings/home_binding.dart
import 'package:get/get.dart';
import '../controllers/refuel_controller.dart';
import '../controllers/stats_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RefuelController>(() => RefuelController());
    Get.lazyPut<StatsController>(() => StatsController());
  }
}