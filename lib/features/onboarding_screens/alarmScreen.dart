import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alarm_application/services/alarm_service.dart';
import '../../common_widgets/alarm_card.dart';
import '../../common_widgets/alerm_sheet.dart';
import '../../constants/color.dart';
import '../../constants/typography.dart';
import '../../helper/responsive.dart';
import '../../model/alarm_model.dart';
import '../location/locationService.dart';
import 'alarm_ring_screen.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Alarm> alarms = [];
  String? _selectedLocation;
  bool _isLoadingLocation = false;

  final SimpleAlarmService _alarmService = SimpleAlarmService();
  Timer? _alarmCheckTimer;

  @override
  void initState() {
    super.initState();
    _initializeAlarmService(); // Initialize alarm service
    _loadLocation();
    _initializeAlarms();
  }

  // ========== ALARM SERVICE METHODS ==========

  Future<void> _initializeAlarmService() async {
    await _alarmService.initialize();

    // Listen for when alarm rings
    _alarmService.onAlarmRing = (alarmName) {
      _showAlarmRingScreen(alarmName);
    };

    // Start checking for alarms
    _startAlarmChecker();
  }

  void _startAlarmChecker() {
    _alarmCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_alarmService.isAlarmPlaying()) {
        _showAlarmRingScreen(_alarmService.getAlarmName() ?? "Alarm");
      }
    });
  }

  void _showAlarmRingScreen(String alarmName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmRingScreen(alarmName: alarmName),
      ),
    );
  }

  // This method actually sets the alarm in the service
  Future<void> _toggleAlarm(int index, bool value) async {
    setState(() {
      alarms[index].isEnabled = value;
    });

    if (value) {
      // Set the alarm
      final alarm = alarms[index];
      final now = DateTime.now();
      final parts = alarm.time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Create alarm time for today
      var alarmTime = DateTime(now.year, now.month, now.day, hour, minute);

      // If time has passed today, set for tomorrow
      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(Duration(days: 1));
      }

      print("🕒 Setting alarm for: ${alarmTime.hour}:${alarmTime.minute}");

      await _alarmService.setAlarm(
        alarmTime,
        alarmName: "Alarm ${alarm.time}",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Alarm set for ${alarm.time}"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Cancel the alarm
      await _alarmService.cancelAlarm();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Alarm cancelled"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Test alarm button
  void _testAlarm() {
    _alarmService.testAlarm();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Test alarm will ring in 2 seconds"),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // ========== EXISTING METHODS ==========

  void _initializeAlarms() {
    final now = DateTime.now();
    final currentDay = _getDayName(now.weekday);

    setState(() {
      alarms = [
        Alarm(
          time: "19:10",
          isEnabled: false,
          days: [currentDay],
        ),
        Alarm(
          time: "18:55",
          isEnabled: false,
          days: [currentDay],
        ),
        Alarm(
          time: "19:10",
          isEnabled: false,
          days: [currentDay],
        ),
      ];
    });
  }

  String _getDayName(int weekday) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday % 7];
  }

  Future<void> _loadLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    _selectedLocation = LocationService.getLastFetchedCountry();

    if (_selectedLocation == null) {
      _selectedLocation = await LocationService.getCurrentCountry();
    }

    setState(() {
      _isLoadingLocation = false;
    });
  }

  Future<void> _refreshLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    String? country = await LocationService.getCurrentCountry();

    if (country != null) {
      setState(() {
        _selectedLocation = country;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location updated to $country"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to get location"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoadingLocation = false;
    });
  }

  void _showAddAlarmDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Responsive.hp(3)),
        ),
      ),
      builder: (context) {
        return AddAlarmBottomSheet(
          onSave: (Alarm alarm) {
            setState(() {
              alarms.add(alarm);
            });

            // If alarm is enabled, set it immediately
            if (alarm.isEnabled) {
              _toggleAlarm(alarms.length - 1, true);
            }

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _editAlarm(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      builder: (context) {
        return AddAlarmBottomSheet(
          alarm: alarms[index],
          onSave: (Alarm updatedAlarm) {
            // Cancel old alarm first
            if (alarms[index].isEnabled) {
              _alarmService.cancelAlarm();
            }

            setState(() {
              alarms[index] = updatedAlarm;
            });

            // Set new alarm if enabled
            if (updatedAlarm.isEnabled) {
              _toggleAlarm(index, true);
            }

            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _deleteAlarm(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Alarm"),
        content: Text("Are you sure you want to delete this alarm?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Cancel alarm if it was set
              if (alarms[index].isEnabled) {
                _alarmService.cancelAlarm();
              }

              setState(() {
                alarms.removeAt(index);
              });
              Navigator.pop(context);
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

  @override
  void dispose() {
    _alarmCheckTimer?.cancel();
    _alarmService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Location Section
            _buildLocationSection(),

            // Alarms Text with Test Button
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.wp(5),
                right: Responsive.wp(5),
                top: Responsive.hp(3),
                bottom: Responsive.hp(2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Alarms",
                    style: AppTypography.large.copyWith(
                      fontSize: Responsive.hp(3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Test Button
                  IconButton(
                    onPressed: _testAlarm,
                    icon: Icon(Icons.play_arrow, color: AppColors.buttonBackgroundColor),
                    tooltip: "Test alarm",
                  ),
                ],
              ),
            ),

            SizedBox(height: Responsive.hp(1)),

            // Alarm List
            Expanded(
              child: alarms.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.alarm,
                      size: Responsive.hp(10),
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: Responsive.hp(2)),
                    Text(
                      "No alarms yet",
                      style: TextStyle(
                        fontSize: Responsive.hp(2.5),
                        color: Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(height: Responsive.hp(1)),
                    Text(
                      "Tap + to add your first alarm",
                      style: TextStyle(
                        fontSize: Responsive.hp(1.8),
                        color: Colors.grey.shade400,
                      ),
                    ),
                    SizedBox(height: Responsive.hp(3)),
                    ElevatedButton(
                      onPressed: _testAlarm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Test Alarm Sound"),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: Responsive.wp(5)),
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  return AlarmCard(
                    alarm: alarms[index],
                    onToggle: (value) {
                      _toggleAlarm(index, value); // Fixed: calls actual alarm service
                    },
                    onEdit: () {
                      _editAlarm(index);
                    },
                    onDelete: () {
                      _deleteAlarm(index);
                    },
                  );
                },
              ),
            ),

            // Bottom padding for FAB
            SizedBox(height: Responsive.hp(8)),
          ],
        ),
      ),

      // Floating Action Button for adding alarms
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: Responsive.height(20)),
        child: FloatingActionButton(
          onPressed: _showAddAlarmDialog,
          backgroundColor: AppColors.buttonBackgroundColor,
          foregroundColor: Colors.white,
          shape: CircleBorder(),
          child: Icon(Icons.add, size: Responsive.hp(3.5)),
          elevation: 4,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildLocationSection() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.wp(5),
        vertical: Responsive.hp(2),
      ),
      padding: EdgeInsets.all(Responsive.hp(2.5)),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(Responsive.hp(2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected Location",
            style: TextStyle(
              fontSize: Responsive.hp(2),
              color: AppColors.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Responsive.hp(1)),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.wp(4),
              vertical: Responsive.hp(1.5),
            ),
            decoration: BoxDecoration(
              color: AppColors.buttonBackgroundColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(Responsive.hp(1.5)),
              border: Border.all(
                color: AppColors.buttonBackgroundColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.buttonBackgroundColor,
                  size: Responsive.hp(2.5),
                ),
                SizedBox(width: Responsive.wp(3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isLoadingLocation)
                        Row(
                          children: [
                            SizedBox(
                              width: Responsive.hp(2),
                              height: Responsive.hp(2),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.buttonBackgroundColor,
                              ),
                            ),
                            SizedBox(width: Responsive.wp(2)),
                            Text(
                              "Fetching location...",
                              style: TextStyle(
                                fontSize: Responsive.hp(2),
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          _selectedLocation ?? "No location selected",
                          style: TextStyle(
                            fontSize: Responsive.hp(2.2),
                            fontWeight: FontWeight.w600,
                            color: _selectedLocation != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),

                      if (_selectedLocation != null && !_isLoadingLocation)
                        Text(
                          "Tap refresh to update",
                          style: TextStyle(
                            fontSize: Responsive.hp(1.5),
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),

                if (!_isLoadingLocation)
                  Row(
                    children: [
                      IconButton(
                        onPressed: _refreshLocation,
                        icon: Icon(
                          Icons.refresh,
                          color: AppColors.buttonBackgroundColor,
                          size: Responsive.hp(2.5),
                        ),
                        tooltip: "Refresh location",
                      ),
                      if (_selectedLocation == null)
                        TextButton(
                          onPressed: _refreshLocation,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: Responsive.wp(3),
                              vertical: Responsive.hp(0.5),
                            ),
                            backgroundColor: AppColors.buttonBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Responsive.hp(1)),
                            ),
                          ),
                          child: Text(
                            "Select",
                            style: TextStyle(
                              fontSize: Responsive.hp(1.8),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}