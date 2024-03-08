class TimeNow {
  DateTime now = DateTime.now();
  late String dateNow;

  TimeNow() {
    dateNow =
        "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
  }
}
