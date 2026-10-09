import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hotkeys/smart_hotkeys.dart';
import 'demo_controller.dart';

class ModifierChip extends ConsumerWidget {
  const ModifierChip({required this.modifier, super.key});
  final HotkeyModifier modifier;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demo = ref.watch(demoProvider);
    return FilterChip(
      label: Text(modifier.label),
      selected: demo.candidate.modifiers & modifier.mask != 0,
      onSelected: demo.busy
          ? null
          : (_) => ref.read(demoProvider.notifier).toggleModifier(modifier),
    );
  }
}
