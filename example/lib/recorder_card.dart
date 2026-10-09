import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hotkeys/smart_hotkeys.dart';
import 'demo_controller.dart';
import 'modifier_chip.dart';

class RecorderCard extends ConsumerWidget {
  const RecorderCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demo = ref.watch(demoProvider);
    final controller = ref.read(demoProvider.notifier);
    return Focus(
      autofocus: demo.recording,
      onKeyEvent: (_, event) {
        if (!demo.recording) return KeyEventResult.ignored;
        controller.record(event);
        return KeyEventResult.handled;
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Новое сочетание',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                demo.recording
                    ? 'Нажмите и отпустите сочетание…'
                    : demo.candidate.label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xff64d7b0),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Builder(
                    builder: (context) => OutlinedButton.icon(
                      onPressed: demo.busy
                          ? null
                          : () {
                              controller.edit(record: true);
                              Focus.of(context).requestFocus();
                            },
                      icon: const Icon(Icons.keyboard),
                      label: const Text('Записать с клавиатуры'),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<int>(
                      initialValue: demo.candidate.usbHidUsage,
                      key: ValueKey(demo.candidate.usbHidUsage),
                      decoration: const InputDecoration(
                        labelText: 'Основная клавиша',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        for (final entry in supportedHotkeyKeys.entries)
                          DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                      ],
                      onChanged: demo.busy
                          ? null
                          : (value) {
                              if (value != null) controller.setKey(value);
                            },
                    ),
                  ),
                  for (final modifier in HotkeyModifier.values)
                    ModifierChip(modifier: modifier),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: [
                  FilledButton.icon(
                    onPressed: demo.busy || demo.recording
                        ? null
                        : controller.add,
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить сочетание'),
                  ),
                  if (demo.editing)
                    TextButton(
                      onPressed: demo.busy ? null : controller.cancelEdit,
                      child: const Text('Отменить настройку'),
                    ),
                ],
              ),
              if (demo.editing)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'Хоткеи временно выключены до добавления или отмены.',
                  ),
                ),
              const SizedBox(height: 8),
              const Text(
                'F13–F24 можно выбрать из списка без специальной клавиатуры. Настройки этого примера хранятся до закрытия приложения.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
