import 'package:flutter/material.dart';
import 'demo_screen.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Smart Hotkeys — лаборатория',
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff64d7b0),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xff10171d),
    ),
    home: const DemoScreen(),
  );
}
