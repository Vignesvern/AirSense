import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:indoor_air_quality_check/pages/dashboard.dart';
import 'package:indoor_air_quality_check/pages/home.dart';
import 'package:indoor_air_quality_check/pages/progress.dart';
import 'package:indoor_air_quality_check/pages/welcome_screen.dart';
import 'package:indoor_air_quality_check/theme/theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: '',
      appId: '1:782286485249:android:2e4f562335b9a548a58d00',
      databaseURL: "https://airsense-cf390-default-rtdb.asia-southeast1.firebasedatabase.app",
      messagingSenderId: '782286485249',
      projectId: 'airsense-cf390',
      storageBucket: 'airsense-cf390.appspot.com',
      // Your web Firebase config options
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      routes: {
        '/home' : (context) => HomeScreen(),
        //'/progress_page' : (context) => ProgressPage(),
        //'/rooms_page' : (context) => HomeScreen(),
      },
      home: const WelcomeScreen(),
    );
  }
}
