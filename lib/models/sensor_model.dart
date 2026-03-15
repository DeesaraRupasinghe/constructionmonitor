/// Model class representing a single sensor log entry from Firebase.
///
/// Each entry contains sensor readings for distance, soil moisture,
/// tilt (X and Y axes), vibration, and a timestamp.
class SensorData {
  /// Distance reading from the ultrasonic sensor (in cm).
  final double distance;

  /// Soil moisture level from the moisture sensor.
  final double soilMoisture;

  /// Tilt angle along the X axis (in degrees).
  final double tiltX;

  /// Tilt angle along the Y axis (in degrees).
  final double tiltY;

  /// Vibration intensity reading from the vibration sensor.
  final double vibration;

  /// Unix timestamp (in milliseconds) when the reading was recorded.
  final int timestamp;

  /// Creates a [SensorData] instance with the given sensor values.
  const SensorData({
    required this.distance,
    required this.soilMoisture,
    required this.tiltX,
    required this.tiltY,
    required this.vibration,
    required this.timestamp,
  });

  /// Creates a [SensorData] instance from a Firebase Realtime Database map.
  ///
  /// Handles both int and double values from the database by converting
  /// all numeric fields to double via [_toDouble], and timestamp to int
  /// via [_toInt].
  factory SensorData.fromMap(Map<dynamic, dynamic> map) {
    return SensorData(
      distance: _toDouble(map['distance']),
      soilMoisture: _toDouble(map['soilMoisture']),
      tiltX: _toDouble(map['tiltX']),
      tiltY: _toDouble(map['tiltY']),
      vibration: _toDouble(map['vibration']),
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

  /// Returns a human-readable date/time string from the [timestamp].
  ///
  /// Converts the Unix timestamp (milliseconds) to a local DateTime string.
  String get formattedTimestamp {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)} '
        '${_pad(dateTime.hour)}:${_pad(dateTime.minute)}:${_pad(dateTime.second)}';
  }

  /// Pads a single-digit number with a leading zero.
  static String _pad(int value) => value.toString().padLeft(2, '0');

  @override
  String toString() {
    return 'SensorData(distance: $distance, soilMoisture: $soilMoisture, '
        'tiltX: $tiltX, tiltY: $tiltY, vibration: $vibration, '
        'timestamp: $timestamp)';
  }
}
