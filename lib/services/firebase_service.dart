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
    final query = _databaseRef.child('sensorLogs').limitToLast(1);

    return query.onChildAdded.map((DatabaseEvent event) {
      final snapshot = event.snapshot;

      if (!snapshot.exists || snapshot.value == null) {
        return null;
      }

      final raw = snapshot.value;
      if (raw is! Map) {
        return null;
      }

      final sensorMap = Map<dynamic, dynamic>.from(raw);

      try {
        return SensorData.fromMap(sensorMap);
      } catch (_) {
        return null;
      }
    });
  }
}
