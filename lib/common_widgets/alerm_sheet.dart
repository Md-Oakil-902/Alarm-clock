// lib/common_widgets/add_alarm_bottom_sheet.dart
import 'package:flutter/material.dart';


import '../constants/color.dart';
import '../helper/responsive.dart';
import '../model/alarm_model.dart';

class AddAlarmBottomSheet extends StatefulWidget {
  final Alarm? alarm;
  final Function(Alarm) onSave;

  const AddAlarmBottomSheet({
    super.key,
    this.alarm,
    required this.onSave,
  });

  @override
  State<AddAlarmBottomSheet> createState() => _AddAlarmBottomSheetState();
}

class _AddAlarmBottomSheetState extends State<AddAlarmBottomSheet> {
  late TimeOfDay _selectedTime;
  final List<bool> _selectedDays = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    if (widget.alarm != null) {
      final timeParts = widget.alarm!.time.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
      // Set days from alarm
      final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      for (var day in widget.alarm!.days) {
        int index = dayNames.indexOf(day);
        if (index != -1) {
          _selectedDays[index] = true;
        }
      }
    } else {
      _selectedTime = TimeOfDay.now();
      // Default: Select today's day
      final today = DateTime.now().weekday % 7; // 0=Sun, 6=Sat
      _selectedDays[today] = true;
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.cardColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: Responsive.wp(5),
        right: Responsive.wp(5),
        top: Responsive.hp(3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: Responsive.hp(2),
                    color: Colors.grey,
                  ),
                ),
              ),
              Text(
                widget.alarm != null ? "Edit Alarm" : "Add Alarm",
                style: TextStyle(
                  fontSize: Responsive.hp(2.2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _saveAlarm,
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: Responsive.hp(2),
                    color: AppColors.buttonBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.hp(3)),

          // Time Picker
          GestureDetector(
            onTap: _selectTime,
            child: Container(
              padding: EdgeInsets.all(Responsive.hp(3)),
              decoration: BoxDecoration(
                color: AppColors.buttonBackgroundColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Responsive.hp(2)),
              ),
              child: Center(
                child: Text(
                  "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: Responsive.hp(6),
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonBackgroundColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: Responsive.hp(3)),

          // Repeat Days
          Text(
            "Repeat",
            style: TextStyle(
              fontSize: Responsive.hp(2),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Responsive.hp(2)),
          Wrap(
            spacing: Responsive.wp(2),
            runSpacing: Responsive.hp(1),
            children: List.generate(7, (index) {
              return ChoiceChip(
                label: Text(dayNames[index]),
                selected: _selectedDays[index],
                onSelected: (selected) {
                  setState(() {
                    _selectedDays[index] = selected;
                  });
                },
                selectedColor: AppColors.buttonBackgroundColor,
                labelStyle: TextStyle(
                  color: _selectedDays[index] ? Colors.white : Colors.black,
                  fontSize: Responsive.hp(1.8),
                ),
              );
            }),
          ),
          SizedBox(height: Responsive.hp(4)),
        ],
      ),
    );
  }

  void _saveAlarm() {
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final selectedDayNames = <String>[];
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) {
        selectedDayNames.add(dayNames[i]);
      }
    }

    final alarm = Alarm(
      time: "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}",
      isEnabled: true,
      days: selectedDayNames.isNotEmpty ? selectedDayNames : ["Once"],
    );

    widget.onSave(alarm);
  }
}