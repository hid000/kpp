# Job Search — трекер пошуку роботи

Flutter-застосунок з дисципліни «Кросплатформне програмування».

- **ЛР №3** — структура застосунку та екрани за дизайном із Figma без бізнес-логіки.
- **ЛР №4** — автентифікація через Firebase Auth (реєстрація, вхід, відновлення та зміна пароля,
  профіль), валідація форм, аналітика Firebase Analytics, звіти про помилки через Sentry
  (Firebase Crashlytics не підтримує Web). Решта даних (вакансії, компанії, співбесіди)
  поки що захардкоджені в `lib/core/data/mock_data.dart`.

## Екрани

- **Авторизація:** вхід, реєстрація, відновлення пароля через email.
- **Головний екран:** статистика, найближчі співбесіди, останні вакансії, воронка заявок.
- **Профіль:** особисті дані, зміна пароля, перемикач темної теми, вихід.
- **Вакансії:** список із фільтрами, форма нової вакансії, сторінка вакансії з етапами розгляду.
- **Компанії:** картки компаній, діалог додавання.
- **Співбесіди:** заплановані та минулі, календар місяця.

Інтерфейс адаптивний: на широкому екрані бокова навігація, на телефоні нижня.

## Структура

```
lib/
├── main.dart                 точка входу
├── firebase_options.dart     конфігурація Firebase (генерує flutterfire configure)
├── app.dart                  MaterialApp, теми, маршрути
├── routes/app_routes.dart    іменовані маршрути
├── theme/                    кольори, світла й темна теми
├── core/
│   ├── auth/                 AuthRepository (Firebase Auth), AppUser, AuthFailure
│   ├── services/             аналітика, звіти про помилки, AppServices
│   ├── utils/validators.dart правила валідації полів форм
│   ├── data/mock_data.dart   статичні дані
│   ├── models/               Vacancy, Company, Interview, Stage
│   └── widgets/              віджети, що перевикористовуються
└── screens/
    ├── auth/                 вхід, реєстрація, відновлення пароля
    ├── home/                 головний екран
    ├── vacancies/            список, форма, деталі вакансії
    ├── companies/            компанії
    ├── interviews/           співбесіди
    └── profile/              профіль і зміна пароля
```

## Налаштування Firebase

`lib/firebase_options.dart` — заготовка з фіктивними значеннями. Щоб підключити власний проєкт:

```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure --platforms=web   # перезапише lib/firebase_options.dart
```

У консолі Firebase: **Authentication → Sign-in method → Email/Password → Enable**;
**Analytics** вмикається разом із Google Analytics для проєкту.

## Запуск

```bash
flutter pub get
flutter run -d chrome --dart-define=SENTRY_DSN=https://<key>@<org>.ingest.sentry.io/<id>
flutter test
```

Без `SENTRY_DSN` відправлення звітів про помилки вимкнено. Кнопка «Згенерувати тестову
помилку» в профілі (Налаштування) призначена для перевірки інтеграції з Sentry.
