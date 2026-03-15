/// Model class representing a single sensor log entry from Firebase.
///
/// Each entry contains sensor readings for distance, soil moisture,
/// tilt (X and Y axes), vibration, collapse alert, and a device timestamp.
class SensorData {
  /// Distance reading from the ultrasonic sensor (in cm).
  final double distanceCM;

  /// Soil moisture level from the moisture sensor.
  final double soilMoisture;

  /// Tilt angle along the X axis (in degrees).
  final double tiltX;

  /// Tilt angle along the Y axis (in degrees).
  final double tiltY;

  /// Vibration intensity reading from the vibration sensor.
  final double vibration;

  /// Whether a collapse alert has been triggered.
  final bool collapseAlert;

  /// Device timestamp (e.g. millis since boot) from the IoT sensor.
  ///
  /// Note: This is typically the IoT device's uptime counter, not a
  /// Unix timestamp. Use [receivedAt] for the actual wall-clock time.
  final int timestamp;

  /// The wall-clock time when this sensor data was received by the app.
  final DateTime receivedAt;

  /// Creates a [SensorData] instance with the given sensor values.
  ///
  /// If [receivedAt] is not provided, it defaults to the current time.
  SensorData({
    required this.distanceCM,
    required this.soilMoisture,
    required this.tiltX,
    required this.tiltY,
    required this.vibration,
    required this.collapseAlert,
    required this.timestamp,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  /// Creates a [SensorData] instance from a Firebase Realtime Database map.
  ///
  /// Handles both int and double values from the database by converting
  /// all numeric fields to double via [_toDouble], and timestamp to int
  /// via [_toInt].
  factory SensorData.fromMap(Map<dynamic, dynamic> map) {
    return SensorData(
      distanceCM: _toDouble(map['distanceCM']),
      soilMoisture: _toDouble(map['soilMoisture']),
      tiltX: _toDouble(map['tiltX']),
      tiltY: _toDouble(map['tiltY']),
      vibration: _toDouble(map['vibration']),
      collapseAlert: _toBool(map['collapseAlert']),
      timestamp: _toInt(map['timestamp']),
    );
  }

  /// Safely converts a dynamic value to double.
  ///
  /// Returns 0.0 if the value is null or cannot be converted.
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  /// Safely converts a dynamic value to int.
  ///
  /// Returns 0 if the value is null or cannot be converted.
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  /// Safely converts a dynamic value to bool.
  ///
  /// Returns false if the value is null or cannot be converted.
  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  /// Returns a human-readable date/time string from the [timestamp].
  ///
  /// Converts the Unix timestamp (milliseconds) to a local DateTime string.
  /// Note: If the device sends uptime instead of Unix time, prefer
  /// [formattedReceivedAt] for display purposes.
  String get formattedTimestamp {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)} '
        '${_pad(dateTime.hour)}:${_pad(dateTime.minute)}:${_pad(dateTime.second)}';
  }

  /// Returns a human-readable date/time string from [receivedAt].
  ///
  /// This shows the actual wall-clock time when the data was received
  /// by the app, which is reliable even when the IoT device sends
  /// device uptime instead of a Unix timestamp.
  String get formattedReceivedAt {
    return '${receivedAt.year}-${_pad(receivedAt.month)}-${_pad(receivedAt.day)} '
        '${_pad(receivedAt.hour)}:${_pad(receivedAt.minute)}:${_pad(receivedAt.second)}';
  }

  /// Pads a single-digit number with a leading zero.
  static String _pad(int value) => value.toString().padLeft(2, '0');

  @override
  String toString() {
    return 'SensorData(distanceCM: $distanceCM, soilMoisture: $soilMoisture, '
        'tiltX: $tiltX, tiltY: $tiltY, vibration: $vibration, '
        'collapseAlert: $collapseAlert, timestamp: $timestamp)';
  }
}
