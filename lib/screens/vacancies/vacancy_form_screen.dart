import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/models/stage.dart';
import '../../core/models/vacancy.dart';
import '../../core/widgets/widgets.dart';

class VacancyFormScreen extends StatelessWidget {
  const VacancyFormScreen({super.key});

  static const Vacancy _draft = MockData.flutterVacancy;

  @override
  Widget build(BuildContext context) {
    final List<Widget> fields = [
      const AppTextField(
        label: 'Посада *',
        initialValue: 'Junior Flutter Developer',
      ),
      AppDropdownField(
        label: 'Компанія *',
        initialValue: _draft.company,
        items: [for (final c in MockData.companies) c.name],
      ),
      AppDropdownField(
        label: 'Етап розгляду *',
        initialValue: _draft.stage.label,
        items: [for (final s in Stage.values) s.label],
      ),
      AppTextField(
        label: 'Дата подання',
        initialValue: _draft.appliedAt,
        readOnly: true,
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.event),
        ),
      ),
      AppTextField(label: 'Локація', initialValue: _draft.location),
      AppDropdownField(
        label: 'Формат роботи',
        initialValue: _draft.workFormat,
        items: MockData.workFormats,
      ),
      AppTextField(label: 'Зарплатна вилка (грн)', initialValue: _draft.salary),
      AppTextField(
        label: 'Посилання на вакансію',
        initialValue: _draft.link,
        prefixIcon: Icons.link,
        keyboardType: TextInputType.url,
      ),
    ];

    return AppShell(
      selectedIndex: 1,
      title: 'Нова вакансія',
      showBack: true,
      body: PageBody(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double gap = 50;
                  final bool twoColumns = constraints.maxWidth >= 700;
                  final double width = twoColumns
                      ? (constraints.maxWidth - gap) / 2
                      : constraints.maxWidth;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        spacing: gap,
                        runSpacing: 30,
                        children: [
                          for (final field in fields)
                            SizedBox(width: width, child: field),
                        ],
                      ),
                      const SizedBox(height: 30),
                      AppTextField(
                        label: 'Нотатки',
                        initialValue: _draft.notes,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 60),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 20,
                        runSpacing: 12,
                        children: [
                          SecondaryButton(
                            text: 'Скасувати',
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          PrimaryButton(
                            text: 'Зберегти',
                            icon: Icons.check,
                            onPressed: () {
                              showInfoSnackBar(context, 'Вакансію збережено');
                              Navigator.maybePop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
