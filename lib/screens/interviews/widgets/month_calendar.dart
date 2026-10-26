import 'package:flutter/material.dart';

/// Статичний календар місяця з позначеними днями співбесід.
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.title,
    required this.daysInMonth,
    required this.firstWeekday,
    required this.today,
    required this.highlighted,
  });

  final String title;
  final int daysInMonth;

  /// День тижня першого числа: 1 — понеділок, 7 — неділя.
  final int firstWeekday;
  final int today;
  final Set<int> highlighted;

  static const List<String> _weekdays = [
    'Пн',
    'Вт',
    'Ср',
    'Чт',
    'Пт',
    'Сб',
    'Нд',
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final int leading = firstWeekday - 1;
    final int cells = ((leading + daysInMonth) / 7).ceil() * 7;

    Widget dayCell(int index) {
      final int day = index - leading + 1;
      if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
      final bool marked = highlighted.contains(day);
      final bool isToday = day == today;
      return Center(
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: marked ? colors.primary : null,
            border: isToday && !marked
                ? Border.all(color: colors.primary, width: 1.5)
                : null,
          ),
          child: Text(
            '$day',
            style: text.titleMedium?.copyWith(
              color: marked ? colors.onPrimary : null,
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: text.titleLarge)),
                IconButton(
                  tooltip: 'Наступний місяць',
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            Row(
              children: [
                for (final weekday in _weekdays)
                  Expanded(
                    child: Center(child: Text(weekday, style: text.bodyMedium)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            for (int week = 0; week < cells ~/ 7; week++)
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    for (int d = 0; d < 7; d++)
                      Expanded(child: dayCell(week * 7 + d)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
