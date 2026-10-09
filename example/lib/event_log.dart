import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'demo_controller.dart';

class EventLog extends ConsumerWidget {
  const EventLog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(demoProvider.select((state) => state.log));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Журнал событий',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(
              onPressed: ref.read(demoProvider.notifier).clearLog,
              child: const Text('Очистить'),
            ),
          ],
        ),
        Card(
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                log.isEmpty
                    ? 'Нажатия и отпускания появятся здесь. Хранится 100 последних событий.'
                    : log.join('\n'),
                style: const TextStyle(
                  fontFamily: 'Consolas',
                  fontSize: 13,
                  height: 1.7,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
