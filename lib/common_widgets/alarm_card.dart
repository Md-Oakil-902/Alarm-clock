import 'package:flutter/material.dart';


import '../constants/color.dart';
import '../helper/responsive.dart';
import '../model/alarm_model.dart';

class AlarmCard extends StatelessWidget {
  final Alarm alarm;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    final nextDate = _getNextOccurrenceDate(alarm.days);
    final formattedDate = _formatDate(nextDate);

    return GestureDetector(
      onTap: onEdit,
      onLongPress: () => _showDeleteConfirmation(context),
      child: Container(
        constraints: BoxConstraints(
          minHeight: Responsive.hp(9),
        ),
        margin: EdgeInsets.only(bottom: Responsive.hp(1.5)),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.wp(4),
          vertical: Responsive.hp(1.2),
        ),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(Responsive.hp(1.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LEFT SIDE: Time
            SizedBox(
              width: Responsive.wp(22),
              child: Text(
                alarm.time,
                style: TextStyle(
                  fontSize: Responsive.hp(3),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(width: Responsive.wp(2)),

            // RIGHT SIDE: Days only
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [


                ],
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: Responsive.wp(2)),
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: Responsive.hp(1.4),
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),

                Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    value: alarm.isEnabled,
                    onChanged: onToggle,
                    activeColor: AppColors.buttonBackgroundColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Alarm?"),
        content: Text("Are you sure you want to delete this alarm at ${alarm.time}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getNextOccurrenceDate(List<String> days) {
    final now = DateTime.now();
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    for (int i = 0; i < 7; i++) {
      final checkDate = now.add(Duration(days: i));
      final dayName = dayNames[checkDate.weekday % 7];

      if (days.contains(dayName)) {
        return checkDate;
      }
    }

    return now;
  }

  String _formatDate(DateTime date) {
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final dayName = dayNames[date.weekday % 7];
    final monthName = monthNames[date.month - 1];
    final year = date.year;

    return "$dayName ${date.day} $monthName $year"; // ✅ Year included
  }
}