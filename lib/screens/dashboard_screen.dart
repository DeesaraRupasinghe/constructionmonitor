import 'package:flutter/material.dart';

import '../models/sensor_model.dart';
import '../services/firebase_service.dart';
import '../widgets/sensor_card.dart';

/// Dashboard screen that displays real-time IoT sensor data.
///
/// Uses a [StreamBuilder] to listen to the latest sensor data from
/// Firebase Realtime Database and automatically updates the UI
/// when new readings arrive.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// Firebase service instance for fetching sensor data.
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Construction Monitoring IoT'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: StreamBuilder<SensorData?>(
        // Listen to the latest sensor data stream from Firebase
        stream: _firebaseService.getLatestSensorData(),
        builder: (context, snapshot) {
          // Show error message if the stream encounters an error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading sensor data',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Show loading indicator while waiting for initial data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text('Connecting to sensors...'),
                ],
              ),
            );
          }

          // Show message if no data is available
          final sensorData = snapshot.data;
          if (sensorData == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sensors_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No sensor data available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Build the dashboard grid with sensor data cards
          return _buildDashboard(sensorData);
        },
      ),
    );
  }

  /// Builds the scrollable dashboard layout with sensor cards in a grid.
  Widget _buildDashboard(SensorData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard header with last updated timestamp
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.teal.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Last Updated: ${data.formattedReceivedAt}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sensor cards displayed in a responsive grid layout
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              // Distance sensor card
              SensorCard(
                icon: Icons.straighten,
                label: 'Distance',
                value: '${data.distance.toStringAsFixed(2)} cm',
                color: Colors.blue,
              ),

              // Soil moisture sensor card
              SensorCard(
                icon: Icons.water_drop,
                label: 'Soil Moisture',
                value: data.soilMoisture.toStringAsFixed(2),
                color: Colors.brown,
              ),

              // Tilt X axis sensor card
              SensorCard(
                icon: Icons.rotate_left,
                label: 'Tilt X',
                value: '${data.tiltX.toStringAsFixed(2)}°',
                color: Colors.orange,
              ),

              // Tilt Y axis sensor card
              SensorCard(
                icon: Icons.rotate_right,
                label: 'Tilt Y',
                value: '${data.tiltY.toStringAsFixed(2)}°',
                color: Colors.purple,
              ),

              // Vibration sensor card
              SensorCard(
                icon: Icons.vibration,
                label: 'Vibration',
                value: data.vibration.toStringAsFixed(2),
                color: Colors.red,
              ),

              // Timestamp card
              SensorCard(
                icon: Icons.schedule,
                label: 'Timestamp',
                value: data.formattedReceivedAt,
                color: Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
