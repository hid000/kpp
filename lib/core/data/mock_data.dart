import '../models/company.dart';
import '../models/interview.dart';
import '../models/stage.dart';
import '../models/vacancy.dart';

/// Статичні дані замість бекенду (бізнес-логіка не реалізується).
abstract final class MockData {
  static const String firstName = 'Роман';
  static const String lastName = 'Дуб';
  static const String userName = '$firstName $lastName';
  static const String email = 'roman.dub@lpnu.ua';

  static const int totalVacancies = 18;
  static const int activeApplications = 11;
  static const int interviewsThisWeek = 3;
  static const int offers = 1;

  static const Map<Stage, int> funnel = {
    Stage.saved: 4,
    Stage.applied: 6,
    Stage.testTask: 3,
    Stage.interview: 3,
    Stage.offer: 1,
    Stage.rejected: 1,
  };

  static const List<Interview> interviews = [
    Interview(
      day: 14,
      month: 'жов',
      title: 'HR-співбесіда',
      company: 'EPAM',
      position: 'Frontend Developer (React)',
      time: '10:00',
      place: 'Google Meet',
    ),
    Interview(
      day: 16,
      month: 'жов',
      title: 'Технічна співбесіда',
      company: 'SoftServe',
      position: 'Junior Flutter Developer',
      time: '15:30',
      place: 'Офіс, Львів',
    ),
    Interview(
      day: 20,
      month: 'жов',
      title: 'Перевірка тестового завдання',
      company: 'GlobalLogic',
      position: 'QA Engineer',
      time: '12:00',
      place: 'Zoom',
      stage: Stage.testTask,
    ),
    Interview(
      day: 2,
      month: 'жов',
      title: 'Ознайомча розмова з рекрутером',
      company: 'Ciklum',
      position: 'Mobile Developer',
      time: '11:00',
      place: 'Телефон',
      stage: Stage.offer,
      isPast: true,
    ),
  ];

  static List<Interview> get upcomingInterviews =>
      interviews.where((i) => !i.isPast).toList();

  static List<Interview> get pastInterviews =>
      interviews.where((i) => i.isPast).toList();

  /// Вакансія, що показується у формі та на сторінці деталей.
  static const Vacancy flutterVacancy = Vacancy(
    title: 'Junior Flutter Developer',
    company: 'SoftServe',
    stage: Stage.applied,
    appliedAt: '12.10.2026',
    location: 'Львів',
    salary: '30 000 – 40 000',
    link: 'https://careers.softserveinc.com/…',
    notes: 'Підготувати портфоліо та пройти тест з Dart до співбесіди',
  );

  static const List<Vacancy> vacancies = [
    flutterVacancy,
    Vacancy(
      title: 'Frontend Developer (React)',
      company: 'EPAM',
      stage: Stage.interview,
      appliedAt: '08.10.2026',
      location: 'Віддалено',
      workFormat: 'Віддалений',
    ),
    Vacancy(
      title: 'QA Engineer',
      company: 'GlobalLogic',
      stage: Stage.testTask,
      appliedAt: '05.10.2026',
      location: 'Львів',
    ),
    Vacancy(
      title: 'Mobile Developer',
      company: 'Ciklum',
      stage: Stage.offer,
      appliedAt: '28.09.2026',
      location: 'Київ',
    ),
    Vacancy(
      title: 'Backend Developer (.NET)',
      company: 'Intellias',
      stage: Stage.rejected,
      appliedAt: '24.09.2026',
      location: 'Віддалено',
      workFormat: 'Віддалений',
    ),
    Vacancy(
      title: 'Trainee Software Engineer',
      company: 'Lohika',
      stage: Stage.saved,
      location: 'Львів',
    ),
  ];

  static const List<Company> companies = [
    Company(
      name: 'SoftServe',
      city: 'Львів',
      industry: 'ІТ-аутсорсинг',
      vacancyCount: 3,
    ),
    Company(
      name: 'EPAM',
      city: 'Київ',
      industry: 'ІТ-послуги',
      vacancyCount: 4,
    ),
    Company(
      name: 'GlobalLogic',
      city: 'Львів',
      industry: 'Розробка ПЗ',
      vacancyCount: 2,
    ),
    Company(
      name: 'Ciklum',
      city: 'Київ',
      industry: 'Продуктова розробка',
      vacancyCount: 3,
    ),
    Company(
      name: 'Intellias',
      city: 'Львів',
      industry: 'Автомобільне ПЗ',
      vacancyCount: 2,
    ),
    Company(
      name: 'Lohika',
      city: 'Львів',
      industry: 'Розробка ПЗ',
      vacancyCount: 1,
    ),
  ];

  static const List<String> industries = [
    'ІТ-аутсорсинг',
    'ІТ-послуги',
    'Розробка ПЗ',
    'Продуктова розробка',
    'Автомобільне ПЗ',
  ];

  static const List<String> workFormats = ['Офіс', 'Гібридний', 'Віддалений'];
}
