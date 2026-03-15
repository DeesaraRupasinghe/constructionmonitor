import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent duplicate Firebase initialization
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDbfk7tOz3fhlOLnlkWryPuUAny6tN2Zhk',
        appId: '1:000000000000:web:0000000000000000000000',
        messagingSenderId: '000000000000',
        projectId: 'construction-monitoring-iot',
        databaseURL:
        'https://construction-monitoring-iot-default-rtdb.firebaseio.com/',
      ),
    );
  }

  FirebaseDatabase.instance.databaseURL =
  'https://construction-monitoring-iot-default-rtdb.firebaseio.com/';

  runApp(const ConstructionMonitorApp());
}

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