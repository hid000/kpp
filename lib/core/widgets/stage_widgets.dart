import 'package:flutter/material.dart';

import '../models/stage.dart';

/// Кольоровий чип етапу заявки («Подано», «Співбесіда» тощо).
class StageChip extends StatelessWidget {
  const StageChip({super.key, required this.stage});

  final Stage stage;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: stage.containerColor(brightness),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        stage.label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: brightness == Brightness.dark
              ? Colors.white
              : stage.color(brightness),
        ),
      ),
    );
  }
}

/// Рядок воронки заявок: назва етапу, кількість і смуга прогресу.
class FunnelBar extends StatelessWidget {
  const FunnelBar({
    super.key,
    required this.stage,
    required this.value,
    required this.max,
  });

  final Stage stage;
  final int value;
  final int max;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(stage.label, style: text.titleMedium)),
            Text('$value', style: text.titleMedium),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: max == 0 ? 0 : value / max,
            minHeight: 14,
            color: stage.color(colors.brightness),
            backgroundColor: colors.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}

/// Вертикальна шкала етапів розгляду заявки на сторінці вакансії.
class StageTimeline extends StatelessWidget {
  const StageTimeline({super.key, required this.current, required this.dates});

  final Stage current;

  /// Дати проходження етапів; відсутній ключ означає «ще не пройдено».
  final Map<Stage, String> dates;

  static const List<Stage> _flow = [
    Stage.saved,
    Stage.applied,
    Stage.testTask,
    Stage.interview,
    Stage.offer,
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final int currentIndex = _flow.indexOf(current);

    return Column(
      children: [
        for (int i = 0; i < _flow.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _StageDot(done: i <= currentIndex),
                      if (i < _flow.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: i < currentIndex
                                ? colors.primary
                                : colors.outlineVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_flow[i].label, style: text.titleMedium),
                              const SizedBox(height: 4),
                              Text(
                                dates[_flow[i]] ?? '—',
                                style: text.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        if (i == currentIndex)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Поточний',
                              style: text.labelLarge?.copyWith(
                                color: colors.onPrimaryContainer,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StageDot extends StatelessWidget {
  const _StageDot({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? colors.primary : null,
        border: done ? null : Border.all(color: colors.outline, width: 1.5),
      ),
      child: done ? Icon(Icons.check, size: 20, color: colors.onPrimary) : null,
    );
  }
}
