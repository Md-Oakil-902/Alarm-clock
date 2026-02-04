import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/alarm_service.dart';
class AlarmRingScreen extends StatelessWidget {
  final String alarmName;

  const AlarmRingScreen({super.key, required this.alarmName});

  @override
  Widget build(BuildContext context) {
    final alarmService = SimpleAlarmService();

    return Scaffold(
      backgroundColor: Colors.red[50],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.alarm, size: 100, color: Colors.red),
              SizedBox(height: 30),
              Text('ALARM!', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(alarmName, style: TextStyle(fontSize: 24)),
              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  alarmService.stopAlarm();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: Text('STOP ALARM', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),

              SizedBox(height: 20),

              TextButton(
                onPressed: () async {
                  alarmService.stopAlarm();
                  final snoozeTime = DateTime.now().add(Duration(minutes: 5));
                  await alarmService.setAlarm(snoozeTime, alarmName: "$alarmName (Snooze)");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Alarm snoozed for 5 minutes')),
                  );

                  Navigator.pop(context);
                },
                child: Text('SNOOZE (5 min)', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}