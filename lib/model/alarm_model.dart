class Alarm {
  final String time;
  bool isEnabled;
  final List<String> days;

  Alarm({
    required this.time,
    required this.isEnabled,
    required this.days,
  });

  Alarm copyWith({
    String? time,
    bool? isEnabled,
    List<String>? days,
  }) {
    return Alarm(
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'isEnabled': isEnabled,
      'days': days,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      time: json['time'],
      isEnabled: json['isEnabled'],
      days: List<String>.from(json['days']),
    );
  }
}