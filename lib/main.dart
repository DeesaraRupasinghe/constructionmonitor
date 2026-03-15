import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';

/// Entry point of the Construction Monitoring IoT application.
///
/// Initializes Firebase with the provided configuration before
/// launching the Flutter app.
Future<void> main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent duplicate Firebase initialization
  if (Firebase.apps.isEmpty) {
    // Initialize Firebase with the project configuration
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyC-ufRlaSXBZR4uMH8Hz4jzIhf_ITapZCs',
        appId: '1:951766696602:android:3a7a600be4d88ac041d523',
        messagingSenderId: '951766696602',
        projectId: 'construction-monitoring-iot',
        storageBucket: 'construction-monitoring-iot.firebasestorage.app',
        databaseURL:
            'https://construction-monitoring-iot-default-rtdb.firebaseio.com/',
      ),
    );
  }

  // Set the Firebase Realtime Database URL
  FirebaseDatabase.instance.databaseURL =
      'https://construction-monitoring-iot-default-rtdb.firebaseio.com/';

  runApp(const ConstructionMonitorApp());
}

/// Root widget of the Construction Monitoring IoT application.
///
/// Configures the app theme and sets the [DashboardScreen] as the home screen.
class ConstructionMonitorApp extends StatelessWidget {
  const ConstructionMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Construction Monitoring IoT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
