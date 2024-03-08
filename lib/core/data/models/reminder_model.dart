import 'package:day_night_time_picker/lib/state/time.dart';

class Reminder {
  int id;
  Time time;
  bool isEnabled;
  String name;

  Reminder({required this.id, required this.time, this.isEnabled = false, required this.name});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      time: Time(hour: json['hour'], minute: json['minute']),
      isEnabled: json['isEnabled'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': time.hour,
      'minute': time.minute,
      'isEnabled': isEnabled,
      'name': name,
    };
  }
}
