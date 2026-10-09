import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hotkeys/smart_hotkeys.dart';
import 'demo_controller.dart';

class BindingTile extends ConsumerWidget {
  const BindingTile({required this.id, required this.hotkey, super.key});
  final String id;
  final Hotkey hotkey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(
      smartHotkeysProvider.select((state) => state.activeIds.contains(id)),
    );
    return Card(
      child: ListTile(
        leading: Icon(
          active ? Icons.radio_button_checked : Icons.radio_button_off,
          color: active ? Colors.greenAccent : Colors.grey,
        ),
        title: Text(hotkey.label),
        subtitle: Text('$id · ${active ? 'Удерживается' : 'Ожидает'}'),
        trailing: IconButton(
          tooltip: 'Удалить',
          onPressed: () => ref.read(demoProvider.notifier).remove(id),
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}
