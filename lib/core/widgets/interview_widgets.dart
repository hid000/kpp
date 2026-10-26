import 'package:flutter/material.dart';

import '../models/interview.dart';
import 'app_buttons.dart';
import 'stage_widgets.dart';

/// Плашка з датою: число і скорочений місяць.
class DateBadge extends StatelessWidget {
  const DateBadge({
    super.key,
    required this.day,
    required this.month,
    this.muted = false,
    this.size = 60,
  });

  final int day;
  final String month;

  /// Сірий варіант для минулих подій.
  final bool muted;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool dark = colors.brightness == Brightness.dark;
    final Color background = muted
        ? colors.surfaceContainerHighest
        : (dark
              ? colors.primary.withValues(alpha: 0.35)
              : colors.primaryContainer);
    final Color foreground = muted
        ? colors.onSurfaceVariant
        : (dark ? Colors.white : colors.onPrimaryContainer);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.toString().padLeft(2, '0'),
            style: TextStyle(fontSize: size * 0.4, color: foreground),
          ),
          Text(month, style: TextStyle(fontSize: 13, color: foreground)),
        ],
      ),
    );
  }
}

/// Компактний рядок співбесіди (головний екран, сторінка вакансії).
class InterviewRow extends StatelessWidget {
  const InterviewRow({
    super.key,
    required this.interview,
    this.showPlace = false,
    this.showTime = true,
  });

  final Interview interview;

  /// true — підзаголовок «час · місце», інакше «компанія · посада».
  final bool showPlace;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          DateBadge(day: interview.day, month: interview.month),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(interview.title, style: text.titleMedium),
                const SizedBox(height: 4),
                Text(
                  showPlace
                      ? '${interview.time} · ${interview.place}'
                      : interview.subtitle,
                  style: text.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showTime && !showPlace)
            Text(interview.time, style: text.titleMedium),
        ],
      ),
    );
  }
}

/// Картка співбесіди у списку на екрані «Співбесіди».
class InterviewCard extends StatelessWidget {
  const InterviewCard({super.key, required this.interview});

  final Interview interview;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final bool narrow = MediaQuery.sizeOf(context).width < 700;

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: narrow ? 16 : 28,
          vertical: narrow ? 16 : 24,
        ),
        child: Row(
          children: [
            DateBadge(
              day: interview.day,
              month: interview.month,
              muted: interview.isPast,
              size: 70,
            ),
            SizedBox(width: narrow ? 16 : 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(interview.title, style: text.titleLarge),
                  const SizedBox(height: 6),
                  Text(interview.subtitle, style: text.bodyLarge),
                  Text(
                    '${interview.time} · ${interview.place}',
                    style: text.bodyLarge,
                  ),
                  if (narrow) ...[
                    const SizedBox(height: 8),
                    StageChip(stage: interview.stage),
                  ],
                ],
              ),
            ),
            if (!narrow) ...[
              SizedBox(
                width: 220,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: StageChip(stage: interview.stage),
                ),
              ),
              const EditDeleteActions(),
            ],
          ],
        ),
      ),
    );
  }
}
