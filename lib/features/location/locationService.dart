import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static String? _lastFetchedCountry;
  static bool _isRequestingPermission = false;

  static Future<String?> getCurrentCountry() async {
    try {
      // Check location service status
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services are disabled");
        return null;
      }

      // Check and request permission
      LocationPermission permission = await _checkAndRequestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("Location permission denied");
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 10), // Add timeout
      ).catchError((e) {
        print("Error getting position: $e");
        return null;
      });

      if (position == null) {
        print("Failed to get position");
        return null;
      }

      // Get placemarks from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).catchError((e) {
        print("Error getting placemarks: $e");
        return [];
      });

      if (placemarks.isNotEmpty && placemarks.first.country != null) {
        _lastFetchedCountry = placemarks.first.country;
        print("Country found: $_lastFetchedCountry");
        return _lastFetchedCountry;
      }

      print("No country found in placemarks");
      return null;
    } catch (e) {
      print("Error getting country: $e");
      return null;
    }
  }

  static Future<LocationPermission> _checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Request permission for the first time
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  // Check if permission is granted
  static Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check if permission is permanently denied
  static Future<bool> isPermissionPermanentlyDenied() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.deniedForever;
  }

  // Open app settings
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  // Open location settings
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  static void setLastFetchedCountry(String country) {
    _lastFetchedCountry = country;
  }

  static String? getLastFetchedCountry() {
    return _lastFetchedCountry;
  }
}