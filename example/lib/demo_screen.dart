import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hotkeys/smart_hotkeys.dart';
import 'demo_controller.dart';
import 'status_card.dart';
import 'recorder_card.dart';
import 'binding_tile.dart';
import 'event_log.dart';

class DemoScreen extends ConsumerWidget {
  const DemoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotkeys = ref.watch(smartHotkeysProvider);
    final demo = ref.watch(demoProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1060),
            child: ListView(
              padding: const EdgeInsets.all(28),
              children: [
                Text(
                  'SMART HOTKEYS',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: const Color(0xff64d7b0),
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Нажать. Удерживать. Отпустить.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Назначьте сочетание, затем сверните окно и проверьте события. Это тест callback-функций; микрофон не используется.',
                ),
                const SizedBox(height: 20),
                const StatusCard(),
                if (demo.error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SelectableText(
                      demo.error!,
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                const SizedBox(height: 16),
                const RecorderCard(),
                const SizedBox(height: 24),
                Text(
                  'Назначенные сочетания',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                if (hotkeys.bindings.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Пока пусто. Добавьте F13 или запишите своё сочетание.',
                    ),
                  ),
                for (final entry in hotkeys.bindings.entries)
                  BindingTile(id: entry.key, hotkey: entry.value),
                const SizedBox(height: 24),
                const EventLog(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
