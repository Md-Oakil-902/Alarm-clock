import 'package:flutter/material.dart';

import '../../common_widgets/next_button.dart';
import '../../constants/color.dart';
import '../../constants/strings.dart';
import '../../constants/typography.dart';
import '../../helper/responsive.dart';
import '../location/locationService.dart';
import 'alarmScreen.dart';

class LocationFetchingScreen extends StatefulWidget {
  const LocationFetchingScreen({super.key});

  @override
  State<LocationFetchingScreen> createState() => _LocationFetchingScreenState();
}

class _LocationFetchingScreenState extends State<LocationFetchingScreen> {
  bool _isLoading = false;
  bool _countryFetched = false;

  Future<void> _handleLocationPermission() async {
    setState(() {
      _isLoading = true;
    });

    String? country = await LocationService.getCurrentCountry();

    setState(() {
      _isLoading = false;
      _countryFetched = country != null;
    });

    if (country == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to get location. Please enable permissions."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Success - country fetched but not shown
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location permission granted!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.welcome_location_text,
                      style: AppTypography.large,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      AppStrings.location_text,
                      textAlign: TextAlign.center,
                      style: AppTypography.medium,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: Responsive.hp(5),
                    right: Responsive.hp(3),
                    left: Responsive.hp(3),
                  ),
                  child: SizedBox(
                    height: Responsive.hp(27),
                    child: Image.asset("assets/images/locationimage.jpg"),
                  ),
                ),
                SizedBox(height: Responsive.hp(15)),
                Padding(
                  padding: EdgeInsets.only(
                    left: Responsive.hp(3),
                    right: Responsive.hp(3),
                    bottom: Responsive.hp(3),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: Responsive.hp(8),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLocationPermission,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _countryFetched
                            ? Colors.green.withOpacity(0.8)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(69),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _countryFetched
                                ? "Location Enabled"
                                : "Use Current Location",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.hp(2),
                              color: _countryFetched
                                  ? Colors.white
                                  : AppColors.textColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            _countryFetched
                                ? Icons.check_circle
                                : Icons.add_location_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                NextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlarmScreen()),
                    );
                  },
                  text: "Home",
                ),
                SizedBox(height: Responsive.hp(5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}