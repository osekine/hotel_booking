import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_page.dart';

class WindowsWidgetApp extends StatelessWidget {
  const WindowsWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Widget',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        visualDensity: VisualDensity.compact,
      ),
      home: const DashboardPage(),
    );
  }
}
