// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar GetStorage para persistencia local
  await GetStorage.init();

  // Pantalla siempre en portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar transparente
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const FuelTrackApp());
}

class FuelTrackApp extends StatelessWidget {
  const FuelTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FuelTrack',
      debugShowCheckedModeBanner: false,

      // Tema oscuro
      theme:     AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,

      // Rutas GetX
      initialRoute: Routes.SPLASH,
      getPages:     appPages,

      // Locale para formatos
      locale:           const Locale('es', 'CO'),
      fallbackLocale:   const Locale('es', 'CO'),

      // Transiciones por defecto
      defaultTransition: Transition.cupertino,
    );
  }
}