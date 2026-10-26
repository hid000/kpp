import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/models/stage.dart';
import '../../core/models/vacancy.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';

class VacanciesScreen extends StatefulWidget {
  const VacanciesScreen({super.key});

  @override
  State<VacanciesScreen> createState() => _VacanciesScreenState();
}

class _VacanciesScreenState extends State<VacanciesScreen> {
  /// null — фільтр «Усі».
  Stage? _filter;

  List<Vacancy> get _visible => _filter == null
      ? MockData.vacancies
      : MockData.vacancies.where((v) => v.stage == _filter).toList();

  Future<void> _confirmDelete(Vacancy vacancy) async {
    final bool confirmed = await showConfirmDialog(
      context,
      title: 'Видалити вакансію?',
      message:
          'Вакансію «${vacancy.title}» (${vacancy.company}) буде переміщено '
          'до Кошика разом зі співбесідами. Її можна відновити протягом 30 днів.',
      confirmText: 'У Кошик',
      destructive: true,
    );
    if (confirmed && mounted) {
      showInfoSnackBar(context, 'Вакансію переміщено до Кошика');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool narrow = MediaQuery.sizeOf(context).width < 900;
    final TextTheme text = Theme.of(context).textTheme;

    return AppShell(
      selectedIndex: 1,
      title: 'Вакансії',
      body: PageBody(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 16,
            children: [
              const SizedBox(
                width: 650,
                child: AppSearchField(
                  hint: 'Посада або компанія',
                  shortcut: 'Ctrl K',
                ),
              ),
              PrimaryButton(
                text: 'Додати вакансію',
                icon: Icons.add,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.vacancyForm),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _filterChip('Усі', null),
              for (final stage in Stage.values) _filterChip(stage.label, stage),
            ],
          ),
          const SizedBox(height: 20),
          if (narrow)
            for (final vacancy in _visible)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VacancyCard(
                  vacancy: vacancy,
                  onDelete: () => _confirmDelete(vacancy),
                ),
              )
          else
            _VacancyTable(vacancies: _visible, onDelete: _confirmDelete),
          const SizedBox(height: 40),
          Row(
            children: [
              Text(
                '1–${_visible.length} з ${MockData.totalVacancies}',
                style: text.titleMedium,
              ),
              const Spacer(),
              if (!narrow) ...[
                Text(
                  'Підказка: натисніть ? для списку гарячих клавіш',
                  style: text.bodyMedium,
                ),
                const Spacer(),
              ],
              Text('Рядків на сторінці: 6', style: text.titleMedium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, Stage? stage) {
    return ChoiceChip(
      label: Text(label),
      labelStyle: const TextStyle(fontSize: 16),
      showCheckmark: false,
      selected: _filter == stage,
      onSelected: (_) => setState(() => _filter = stage),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _VacancyTable extends StatelessWidget {
  const _VacancyTable({required this.vacancies, required this.onDelete});

  final List<Vacancy> vacancies;
  final ValueChanged<Vacancy> onDelete;

  static const List<int> _flex = [4, 3, 3, 2, 3, 2];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;
    final TextStyle? header = text.bodyLarge?.copyWith(
      color: colors.onSurfaceVariant,
    );

    Widget row(List<Widget> cells, {double height = 80}) => SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            for (int i = 0; i < cells.length; i++)
              Expanded(
                flex: _flex[i],
                child: Align(
                  alignment: i == cells.length - 1
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: cells[i],
                ),
              ),
          ],
        ),
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ColoredBox(
            color: colors.surfaceContainerLow,
            child: row(height: 60, [
              Text('Посада', style: header),
              Text('Компанія', style: header),
              Text('Етап', style: header),
              Text('Подано', style: header),
              Text('Локація', style: header),
              Text('Дії', style: header),
            ]),
          ),
          for (final vacancy in vacancies) ...[
            const Divider(),
            InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.vacancyDetails,
                arguments: vacancy,
              ),
              child: row([
                Text(vacancy.title, style: text.titleMedium),
                Text(vacancy.company, style: text.titleMedium),
                StageChip(stage: vacancy.stage),
                Text(vacancy.appliedAt ?? '—', style: text.titleMedium),
                Text(vacancy.location, style: text.titleMedium),
                EditDeleteActions(
                  onEdit: () =>
                      Navigator.pushNamed(context, AppRoutes.vacancyForm),
                  onDelete: () => onDelete(vacancy),
                ),
              ]),
            ),
          ],
        ],
      ),
    );
  }
}

class _VacancyCard extends StatelessWidget {
  const _VacancyCard({required this.vacancy, required this.onDelete});

  final Vacancy vacancy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.vacancyDetails,
          arguments: vacancy,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vacancy.title, style: text.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '${vacancy.company} · ${vacancy.location}'
                      ' · ${vacancy.appliedAt ?? '—'}',
                      style: text.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    StageChip(stage: vacancy.stage),
                  ],
                ),
              ),
              EditDeleteActions(
                onEdit: () =>
                    Navigator.pushNamed(context, AppRoutes.vacancyForm),
                onDelete: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
