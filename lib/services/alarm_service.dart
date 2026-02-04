import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleAlarmService {
  static final SimpleAlarmService _instance = SimpleAlarmService._internal();
  factory SimpleAlarmService() => _instance;
  SimpleAlarmService._internal();

  AudioPlayer audioPlayer = AudioPlayer();
  Timer? _alarmCheckTimer;
  Timer? _autoStopTimer;
  bool _isAlarmPlaying = false;
  DateTime? _scheduledAlarmTime;
  String? _alarmName;

  // Callback for when alarm rings
  Function(String alarmName)? onAlarmRing;

  // Initialize the service
  Future<void> initialize() async {
    await _loadSavedAlarm();
    _startAlarmChecker();
  }

  // Set alarm with time and name
  Future<void> setAlarm(DateTime alarmTime, {String alarmName = "Alarm"}) async {
    _scheduledAlarmTime = alarmTime;
    _alarmName = alarmName;

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarm_time', alarmTime.toIso8601String());
    await prefs.setString('alarm_name', alarmName);

    debugPrint('Alarm "$alarmName" set for: $alarmTime');
  }

  // Start checking for alarm time
  void _startAlarmChecker() {
    _alarmCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _checkAlarm();
    });
  }

  // Check if it's time for alarm
  void _checkAlarm() {
    if (_scheduledAlarmTime == null || _isAlarmPlaying) return;

    final now = DateTime.now();
    final alarmTime = _scheduledAlarmTime!;

    // Check if current time matches alarm time (within 1 second)
    if (now.year == alarmTime.year &&
        now.month == alarmTime.month &&
        now.day == alarmTime.day &&
        now.hour == alarmTime.hour &&
        now.minute == alarmTime.minute &&
        now.second == alarmTime.second) {

      _playAlarm();
    }
  }

  // Play alarm sound
  Future<void> _playAlarm() async {
    if (_isAlarmPlaying) return;

    _isAlarmPlaying = true;
    debugPrint('🎯 ALARM RINGING: $_alarmName');

    // Notify listeners that alarm is ringing
    if (onAlarmRing != null) {
      onAlarmRing!(_alarmName ?? "Alarm");
    }

    try {
      // Play alarm sound
      await audioPlayer.setAsset('assets/sounds/alarm.mp3');
      await audioPlayer.setLoopMode(LoopMode.all);
      await audioPlayer.play();

      // Vibrate
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(
          pattern: [0, 1000, 500, 1000],
          repeat: -1,
        );
      }

      // Auto-stop after 10 minutes (safety)
      _autoStopTimer = Timer(Duration(minutes: 10), () {
        stopAlarm();
      });

    } catch (e) {
      debugPrint('Error playing alarm: $e');
      _isAlarmPlaying = false;
    }
  }

  // Stop alarm
  Future<void> stopAlarm() async {
    try {
      await audioPlayer.stop();
      Vibration.cancel();
      _isAlarmPlaying = false;
      _autoStopTimer?.cancel();

      // Clear the scheduled alarm after it rings
      _scheduledAlarmTime = null;
      _alarmName = null;

      // Clear from storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('alarm_time');
      await prefs.remove('alarm_name');

      debugPrint('Alarm stopped');
    } catch (e) {
      debugPrint('Error stopping alarm: $e');
    }
  }

  // Cancel/clear alarm without it ringing
  Future<void> cancelAlarm() async {
    _scheduledAlarmTime = null;
    _alarmName = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('alarm_time');
    await prefs.remove('alarm_name');

    debugPrint('Alarm cancelled');
  }

  // Load saved alarm
  Future<void> _loadSavedAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTime = prefs.getString('alarm_time');
    final savedName = prefs.getString('alarm_name');

    if (savedTime != null) {
      _scheduledAlarmTime = DateTime.parse(savedTime);
      _alarmName = savedName ?? "Alarm";
      debugPrint('Loaded saved alarm "$_alarmName": $_scheduledAlarmTime');
    }
  }

  // Check if alarm is set
  bool isAlarmSet() {
    return _scheduledAlarmTime != null;
  }

  // Get alarm time
  DateTime? getAlarmTime() {
    return _scheduledAlarmTime;
  }

  // Get alarm name
  String? getAlarmName() {
    return _alarmName;
  }

  // Check if alarm is playing
  bool isAlarmPlaying() {
    return _isAlarmPlaying;
  }

  // Test alarm immediately
  Future<void> testAlarm({String alarmName = "Test Alarm"}) async {
    await setAlarm(DateTime.now().add(Duration(seconds: 2)), alarmName: alarmName);
  }

  // Clean up
  void dispose() {
    _alarmCheckTimer?.cancel();
    _autoStopTimer?.cancel();
    audioPlayer.dispose();
  }
}