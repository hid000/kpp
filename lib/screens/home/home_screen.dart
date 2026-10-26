import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/models/stage.dart';
import '../../core/models/vacancy.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return AppShell(
      selectedIndex: 0,
      title: 'Головна',
      body: PageBody(
        children: [
          Text('Вітаємо, ${MockData.firstName}!', style: text.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'Ось що відбувається з вашим пошуком роботи',
            style: text.titleMedium,
          ),
          const SizedBox(height: 32),
          const _StatsGrid(),
          const SizedBox(height: 40),
          ResponsiveColumns(
            main: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  title: 'Найближчі співбесіди',
                  trailing: _AllButton(route: AppRoutes.interviews),
                  child: Column(
                    children: [
                      for (final (i, interview)
                          in MockData.upcomingInterviews.indexed) ...[
                        if (i > 0) const Divider(),
                        InterviewRow(interview: interview),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SectionCard(
                  title: 'Останні вакансії',
                  trailing: _AllButton(route: AppRoutes.vacancies),
                  child: Column(
                    children: [
                      for (final (i, vacancy)
                          in MockData.vacancies.take(4).indexed) ...[
                        if (i > 0) const Divider(),
                        _RecentVacancyRow(vacancy: vacancy),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            side: const _FunnelCard(),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    const List<StatCard> cards = [
      StatCard(
        icon: Icons.work,
        value: '${MockData.totalVacancies}',
        label: 'Усього вакансій',
      ),
      StatCard(
        icon: Icons.check,
        value: '${MockData.activeApplications}',
        label: 'Активні заявки',
      ),
      StatCard(
        icon: Icons.event,
        value: '${MockData.interviewsThisWeek}',
        label: 'Співбесіди (7 днів)',
      ),
      StatCard(
        icon: Icons.person,
        value: '${MockData.offers}',
        label: 'Пропозиції',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const double gap = 30;
        final int columns = constraints.maxWidth >= 1100
            ? 4
            : constraints.maxWidth >= 520
            ? 2
            : 1;
        final double width =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap / 2,
          children: [
            for (final card in cards) SizedBox(width: width, child: card),
          ],
        );
      },
    );
  }
}

class _AllButton extends StatelessWidget {
  const _AllButton({required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
          Navigator.pushNamedAndRemoveUntil(context, route, (_) => false),
      style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 16)),
      child: const Text('Усі'),
    );
  }
}

class _RecentVacancyRow extends StatelessWidget {
  const _RecentVacancyRow({required this.vacancy});

  final Vacancy vacancy;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final bool narrow = MediaQuery.sizeOf(context).width < 700;

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.vacancyDetails,
        arguments: vacancy,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: narrow
            ? Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vacancy.title, style: text.titleMedium),
                        Text(vacancy.company, style: text.bodyMedium),
                      ],
                    ),
                  ),
                  StageChip(stage: vacancy.stage),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(vacancy.title, style: text.titleMedium),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(vacancy.company, style: text.titleMedium),
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: StageChip(stage: vacancy.stage),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FunnelCard extends StatelessWidget {
  const _FunnelCard();

  @override
  Widget build(BuildContext context) {
    final int max = MockData.funnel.values.reduce((a, b) => a > b ? a : b);
    return SectionCard(
      title: 'Воронка заявок',
      showDivider: false,
      child: Column(
        children: [
          for (final Stage stage in Stage.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: FunnelBar(
                stage: stage,
                value: MockData.funnel[stage] ?? 0,
                max: max,
              ),
            ),
        ],
      ),
    );
  }
}
