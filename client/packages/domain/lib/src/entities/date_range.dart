class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end}) {
    if (!end.isAfter(start)) throw ArgumentError('end must be after start');
  }
}
