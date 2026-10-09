import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hotkeys/smart_hotkeys.dart';
import 'demo_controller.dart';

class StatusCard extends ConsumerWidget {
  const StatusCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotkeys = ref.watch(smartHotkeysProvider);
    final demo = ref.watch(demoProvider);
    final active = hotkeys.activeIds.isNotEmpty;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 24,
          runSpacing: 14,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              active ? Icons.mic : Icons.mic_off,
              size: 36,
              color: active ? Colors.greenAccent : Colors.grey,
            ),
            Text(
              active ? 'ДЕЙСТВИЕ АКТИВНО' : 'Ожидание нажатия',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'PRESS ${demo.pressedCount}  /  RELEASE ${demo.releasedCount}\n${hotkeys.backend.isEmpty ? 'Нет подключения' : hotkeys.backend}',
            ),
            FilledButton.tonal(
              onPressed: demo.busy || demo.editing || !hotkeys.initialized
                  ? null
                  : ref.read(demoProvider.notifier).togglePause,
              child: Text(hotkeys.paused ? 'Возобновить' : 'Пауза'),
            ),
            if (!hotkeys.initialized)
              OutlinedButton(
                onPressed: demo.busy
                    ? null
                    : ref.read(demoProvider.notifier).initialize,
                child: const Text('Подключить'),
              ),
            if (demo.busy)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }
}
