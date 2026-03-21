import 'package:flutter/services.dart';

/// Inicialização mínima antes do runApp (cache, orientação, etc.).
class AppBootstrap {
  static Future<void> init() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
