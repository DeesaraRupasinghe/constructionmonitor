import 'package:firebase_database/firebase_database.dart';

import '../models/sensor_model.dart';

/// Service class for interacting with Firebase Realtime Database.
///
/// Provides a real-time stream of the latest sensor data from the
/// "sensorLogs" node, ordered by the timestamp field.
class FirebaseService {
  /// Reference to the Firebase Realtime Database instance.
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  /// Returns a [Stream] that emits the latest [SensorData] entry
  /// whenever new data is added to the "sensorLogs" node.
  ///
  /// The query orders entries by the "timestamp" field and limits
  /// the result to the last (most recent) entry. Each time a new
  /// sensor log is pushed, the stream emits the updated latest value.
  Stream<SensorData?> getLatestSensorData() {
    // Query the sensorLogs node, ordered by timestamp, and limit to the last entry
    final query = _databaseRef
        .child('sensorLogs')
        .orderByChild('timestamp')
        .limitToLast(1);

    // Listen to real-time value changes and map to SensorData
    return query.onValue.map((DatabaseEvent event) {
      final snapshot = event.snapshot;

      // Return null if no data exists at the node
      if (!snapshot.exists || snapshot.value == null) {
        return null;
      }

      // The snapshot value is a Map with one auto-generated key
      final data = Map<dynamic, dynamic>.from(snapshot.value as Map);

      // Extract the first (and only) entry from the map
      final firstKey = data.keys.first;
      final sensorMap = Map<dynamic, dynamic>.from(data[firstKey] as Map);

      return SensorData.fromMap(sensorMap);
    });
  }
}
