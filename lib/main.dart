import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/onboarding_screens/location_fetching_screen.dart';
import 'features/onboarding_screens/onboarding_screen1.dart';
import 'helper/responsive.dart';



void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child){
        Responsive.init(context);
        return child!;
      },
      home: FirstScreen(),
    );
  }
}
