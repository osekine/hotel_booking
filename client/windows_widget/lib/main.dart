import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Опционально: фиксируем "виджетные" размеры
  const windowOptions = WindowOptions(
    size: Size(420, 560),
    minimumSize: Size(360, 420),
    center: true,
    title: 'Booking Widget',
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: WindowsWidgetApp()));
}