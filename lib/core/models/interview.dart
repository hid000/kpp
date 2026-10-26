import 'stage.dart';

class Interview {
  const Interview({
    required this.day,
    required this.month,
    required this.title,
    required this.company,
    required this.position,
    required this.time,
    required this.place,
    this.stage = Stage.interview,
    this.isPast = false,
  });

  final int day;
  final String month;
  final String title;
  final String company;
  final String position;
  final String time;
  final String place;
  final Stage stage;
  final bool isPast;

  String get subtitle => '$company · $position';
}
