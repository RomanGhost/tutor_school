// Модель данных для уроков


class Lesson {
  late final int _id;
  late final String _title;
  late final DateTime _time;
  late final String _status;

  void set id(id) => _id=id;

  int get id => _id;
  String get title => _title;
  DateTime get time => _time;
  String get status => _status;

  Lesson({int id=0, required String title, required DateTime time, required String status}) {
    _title = title;
    DateTime localTime = time.toLocal();
    _time=localTime;
    _status=status;
    _id=id;
  }

  @override
  String toString() {
    final String formattedTime = _formatTimeOfDay(_time);
    return '$_title в $formattedTime';
  }

  String _formatTimeOfDay(DateTime time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}