import 'stage.dart';

class Vacancy {
  const Vacancy({
    required this.title,
    required this.company,
    required this.stage,
    required this.location,
    this.appliedAt,
    this.workFormat = 'Гібридний',
    this.salary = '',
    this.link = '',
    this.notes = '',
  });

  final String title;
  final String company;
  final Stage stage;
  final String location;
  final String? appliedAt;
  final String workFormat;
  final String salary;
  final String link;
  final String notes;
}
