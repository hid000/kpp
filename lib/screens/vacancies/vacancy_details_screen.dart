import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/models/interview.dart';
import '../../core/models/stage.dart';
import '../../core/models/vacancy.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';

class VacancyDetailsScreen extends StatelessWidget {
  const VacancyDetailsScreen({super.key, Vacancy? vacancy})
    : vacancy = vacancy ?? _fallback;

  static const Vacancy _fallback = MockData.flutterVacancy;

  final Vacancy vacancy;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final Iterable<Interview> interviews = MockData.interviews.where(
      (i) => i.company == vacancy.company && !i.isPast,
    );

    return AppShell(
      selectedIndex: 1,
      title: vacancy.title,
      showBack: true,
      body: PageBody(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 12,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  '${vacancy.company} · ${vacancy.location}',
                  style: text.titleMedium,
                ),
              ),
              Wrap(
                spacing: 16,
                children: [
                  SecondaryButton(
                    text: 'Редагувати',
                    icon: Icons.edit,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.vacancyForm),
                  ),
                  DangerTextButton(
                    text: 'Видалити',
                    icon: Icons.delete,
                    onPressed: () => showConfirmDialog(
                      context,
                      title: 'Видалити вакансію?',
                      message:
                          'Вакансію «${vacancy.title}» (${vacancy.company}) '
                          'буде переміщено до Кошика разом зі співбесідами. '
                          'Її можна відновити протягом 30 днів.',
                      confirmText: 'У Кошик',
                      destructive: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ResponsiveColumns(
            main: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  title: 'Інформація про вакансію',
                  showDivider: false,
                  child: _InfoGrid(vacancy: vacancy),
                ),
                const SizedBox(height: 30),
                SectionCard(
                  title: 'Співбесіди по вакансії',
                  showDivider: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final interview in interviews)
                        InterviewRow(interview: interview, showPlace: true),
                      TextButton.icon(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.interviews,
                          (_) => false,
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Запланувати співбесіду'),
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            side: _StagesCard(vacancy: vacancy),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.vacancy});

  final Vacancy vacancy;

  @override
  Widget build(BuildContext context) {
    final List<InfoField> fields = [
      InfoField(label: 'Компанія', value: vacancy.company),
      InfoField(label: 'Локація', value: vacancy.location),
      InfoField(label: 'Формат роботи', value: vacancy.workFormat),
      InfoField(
        label: 'Зарплатна вилка',
        value: vacancy.salary.isEmpty ? '—' : '${vacancy.salary} грн',
      ),
      InfoField(label: 'Дата подання', value: vacancy.appliedAt ?? '—'),
      InfoField(
        label: 'Посилання',
        value: vacancy.link.isEmpty ? '—' : 'careers.softserveinc.com',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth >= 500
            ? constraints.maxWidth / 2
            : constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              runSpacing: 24,
              children: [
                for (final field in fields)
                  SizedBox(width: width, child: field),
              ],
            ),
            if (vacancy.notes.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 20),
              Text(
                'Нотатки: ${vacancy.notes[0].toLowerCase()}'
                '${vacancy.notes.substring(1)}.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _StagesCard extends StatelessWidget {
  const _StagesCard({required this.vacancy});

  final Vacancy vacancy;

  @override
  Widget build(BuildContext context) {
    final Stage next = switch (vacancy.stage) {
      Stage.saved => Stage.applied,
      Stage.applied => Stage.testTask,
      Stage.testTask => Stage.interview,
      _ => Stage.offer,
    };

    return SectionCard(
      title: 'Етапи розгляду заявки',
      showDivider: false,
      trailing: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.history),
        label: const Text('Історія змін'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StageTimeline(
            current: vacancy.stage,
            dates: const {
              Stage.saved: '10.10.2026',
              Stage.applied: '12.10.2026',
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Натисніть на етап, щоб повернути заявку на нього',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Перейти до: ${next.label}',
                  expanded: true,
                  onPressed: () => showInfoSnackBar(
                    context,
                    'Етап змінено на «${next.label}»',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton.outlined(
                tooltip: 'Інші дії',
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
                style: IconButton.styleFrom(minimumSize: const Size(52, 52)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
