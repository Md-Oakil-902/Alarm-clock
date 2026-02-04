import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RingtoneManager {
  static final List<Map<String, dynamic>> defaultRingtones = [
    {
      'name': 'Classic Alarm',
      'path': 'assets/sounds/alarm.mp3',
      'isAsset': true,
    },
    {
      'name': 'Digital Beep',
      'path': 'assets/sounds/digital.mp3',
      'isAsset': true,
    },
    {
      'name': 'Morning Birds',
      'path': 'assets/sounds/birds.mp3',
      'isAsset': true,
    },
    {
      'name': 'Gentle Chime',
      'path': 'assets/sounds/chime.mp3',
      'isAsset': true,
    },
  ];

  static final List<Map<String, dynamic>> vibrationPatterns = [
    {
      'name': 'Default',
      'pattern': 0,
      'description': 'Strong vibration',
    },
    {
      'name': 'Short Bursts',
      'pattern': 1,
      'description': 'Quick vibrations',
    },
    {
      'name': 'Long Bursts',
      'pattern': 2,
      'description': 'Long vibrations',
    },
    {
      'name': 'Heartbeat',
      'pattern': 3,
      'description': 'Pulse-like pattern',
    },
  ];

  // Copy asset ringtone to local storage
  static Future<String> getRingtonePath(String assetPath) async {
    if (!assetPath.startsWith('assets/')) {
      return assetPath; // Already a local file path
    }

    final dir = await getApplicationDocumentsDirectory();
    final filename = assetPath.split('/').last;
    final file = File('${dir.path}/ringtones/$filename');

    // Create directory if it doesn't exist
    await file.parent.create(recursive: true);

    // For actual implementation, you'd copy from assets
    // This is simplified - you need to implement asset copying
    return file.path;
  }
}