import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';

/// Entry point of the Construction Monitoring IoT application.
///
/// Initializes Firebase using the native configuration provided by
/// `google-services.json` (Android) before launching the Flutter app.
Future<void> main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase using the native google-services.json configuration.
  // Do not pass explicit FirebaseOptions here — the Google Services Gradle
  // plugin already registers the default app on the native Android side.
  await Firebase.initializeApp();

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
