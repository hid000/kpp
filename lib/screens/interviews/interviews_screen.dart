import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/widgets/widgets.dart';
import 'widgets/month_calendar.dart';

class InterviewsScreen extends StatelessWidget {
  const InterviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return AppShell(
      selectedIndex: 3,
      title: 'Співбесіди',
      body: PageBody(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 16,
            children: [
              Text('Заплановані', style: text.headlineSmall),
              PrimaryButton(
                text: 'Запланувати співбесіду',
                icon: Icons.add,
                onPressed: () => showInfoSnackBar(
                  context,
                  'Форма планування з’явиться в наступних версіях',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ResponsiveColumns(
            main: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final interview in MockData.upcomingInterviews)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: InterviewCard(interview: interview),
                  ),
                const SizedBox(height: 20),
                Text('Минулі', style: text.headlineSmall),
                const SizedBox(height: 30),
                for (final interview in MockData.pastInterviews)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: InterviewCard(interview: interview),
                  ),
              ],
            ),
            side: MonthCalendar(
              title: 'Жовтень 2026',
              daysInMonth: 31,
              firstWeekday: DateTime.thursday,
              today: 12,
              highlighted: {for (final i in MockData.upcomingInterviews) i.day},
            ),
          ),
        ],
      ),
    );
  }
}
