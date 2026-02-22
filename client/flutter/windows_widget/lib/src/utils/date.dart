DateTime startOfDayLocal(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

String fmtDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final yyyy = d.year.toString().padLeft(4, '0');
  return '$dd.$mm.$yyyy';
}

String fmtDateTime(DateTime d) {
  final hh = d.hour.toString().padLeft(2, '0');
  final mi = d.minute.toString().padLeft(2, '0');
  return '${fmtDate(d)} $hh:$mi';
}
