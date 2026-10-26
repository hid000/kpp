import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/models/company.dart';
import '../../core/widgets/widgets.dart';

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({super.key});

  void _openCompanyDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const _CompanyDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: 2,
      title: 'Компанії',
      body: PageBody(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 16,
            children: [
              const SizedBox(
                width: 650,
                child: AppSearchField(hint: 'Назва або місто компанії'),
              ),
              PrimaryButton(
                text: 'Додати компанію',
                icon: Icons.add,
                onPressed: () => _openCompanyDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              const double gap = 30;
              final int columns = constraints.maxWidth >= 1100
                  ? 3
                  : constraints.maxWidth >= 640
                  ? 2
                  : 1;
              final double width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final company in MockData.companies)
                    SizedBox(
                      width: width,
                      child: _CompanyCard(
                        company: company,
                        onEdit: () => _openCompanyDialog(context),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Відмінювання слова «вакансія» за числом.
String _vacanciesLabel(int count) {
  final int mod10 = count % 10;
  final int mod100 = count % 100;
  if (mod10 == 1 && mod100 != 11) return '$count вакансія';
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
    return '$count вакансії';
  }
  return '$count вакансій';
}

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({required this.company, required this.onEdit});

  final Company company;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                InitialsAvatar(text: company.name[0], size: 60),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(company.name, style: text.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        '${company.city} · ${company.industry}',
                        style: text.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Divider(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.work, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _vacanciesLabel(company.vacancyCount),
                    style: text.titleMedium,
                  ),
                ),
                EditDeleteActions(
                  onEdit: onEdit,
                  onDelete: () => showConfirmDialog(
                    context,
                    title: 'Видалити компанію?',
                    message:
                        'Компанію «${company.name}» буде переміщено до Кошика. '
                        'Її можна відновити протягом 30 днів.',
                    confirmText: 'У Кошик',
                    destructive: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyDialog extends StatelessWidget {
  const _CompanyDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Нова компанія'),
      contentPadding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
      titlePadding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
      actionsPadding: const EdgeInsets.all(40),
      content: const SizedBox(
        width: 620,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(label: 'Назва *', initialValue: 'Ciklum'),
              SizedBox(height: 30),
              AppTextField(
                label: 'Вебсайт',
                initialValue: 'https://www.ciklum.com',
                prefixIcon: Icons.link,
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(label: 'Місто', initialValue: 'Київ'),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: AppDropdownField(
                      label: 'Сфера',
                      initialValue: 'Розробка ПЗ',
                      items: MockData.industries,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              AppTextField(
                label: 'Нотатки',
                initialValue: 'Контакт рекрутера: hr@ciklum.com',
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        const SizedBox(width: 20),
        PrimaryButton(
          text: 'Зберегти',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
