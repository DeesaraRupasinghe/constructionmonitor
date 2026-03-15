// Unit tests for the SensorData model class.
//
// These tests verify the sensor data model's parsing, null handling,
// and formatting logic without requiring Firebase connectivity.

import 'package:flutter_test/flutter_test.dart';

import 'package:constructionmonitor/models/sensor_model.dart';

void main() {
  group('SensorData', () {
    test('fromMap creates SensorData with correct values', () {
      // Arrange: create a map simulating Firebase data
      final map = {
        'distance': 25.5,
        'soilMoisture': 450,
        'tiltX': 1.2,
        'tiltY': -0.8,
        'vibration': 3.7,
        'timestamp': 1700000000000,
      };

      // Act: parse the map into a SensorData instance
      final sensor = SensorData.fromMap(map);

      // Assert: verify all fields are correctly parsed
      expect(sensor.distance, 25.5);
      expect(sensor.soilMoisture, 450.0);
      expect(sensor.tiltX, 1.2);
      expect(sensor.tiltY, -0.8);
      expect(sensor.vibration, 3.7);
      expect(sensor.timestamp, 1700000000000);
    });

    test('fromMap handles integer values by converting to double', () {
      // Arrange: create a map with all integer values
      final map = {
        'distance': 10,
        'soilMoisture': 500,
        'tiltX': 2,
        'tiltY': -1,
        'vibration': 4,
        'timestamp': 1700000000000,
      };

      // Act
      final sensor = SensorData.fromMap(map);

      // Assert: verify integers are converted to doubles
      expect(sensor.distance, 10.0);
      expect(sensor.soilMoisture, 500.0);
      expect(sensor.tiltX, 2.0);
      expect(sensor.tiltY, -1.0);
      expect(sensor.vibration, 4.0);
    });

    test('fromMap handles null values with defaults', () {
      // Arrange: create a map with missing fields
      final Map<dynamic, dynamic> map = {
        'timestamp': 1700000000000,
      };

      // Act
      final sensor = SensorData.fromMap(map);

      // Assert: missing fields default to 0.0 / 0
      expect(sensor.distance, 0.0);
      expect(sensor.soilMoisture, 0.0);
      expect(sensor.tiltX, 0.0);
      expect(sensor.tiltY, 0.0);
      expect(sensor.vibration, 0.0);
      expect(sensor.timestamp, 1700000000000);
    });

    test('fromMap handles all null values', () {
      // Arrange: create a completely empty map
      final Map<dynamic, dynamic> map = {};

      // Act
      final sensor = SensorData.fromMap(map);

      // Assert: all fields default to zero
      expect(sensor.distance, 0.0);
      expect(sensor.soilMoisture, 0.0);
      expect(sensor.tiltX, 0.0);
      expect(sensor.tiltY, 0.0);
      expect(sensor.vibration, 0.0);
      expect(sensor.timestamp, 0);
    });

    test('formattedTimestamp returns correct date string', () {
      // Arrange: use a known timestamp (2023-11-14 22:13:20 UTC)
      final sensor = SensorData(
        distance: 0,
        soilMoisture: 0,
        tiltX: 0,
        tiltY: 0,
        vibration: 0,
        timestamp: 1700000000000,
      );

      // Act
      final formatted = sensor.formattedTimestamp;

      // Assert: verify the formatted string contains expected date components
      expect(formatted, contains('2023'));
      expect(formatted, contains('11'));
    });

    test('formattedReceivedAt returns current time, not device uptime', () {
      // Arrange: use a small timestamp simulating IoT device millis()
      final before = DateTime.now();
      final sensor = SensorData(
        distance: 10.0,
        soilMoisture: 734.0,
        tiltX: 1.94,
        tiltY: -2.06,
        vibration: 1.0,
        timestamp: 31791, // device uptime in ms, NOT Unix timestamp
      );
      final after = DateTime.now();

      // Act
      final formatted = sensor.formattedReceivedAt;

      // Assert: receivedAt should be around now, not 1970
      expect(sensor.receivedAt.isAfter(before) || sensor.receivedAt.isAtSameMomentAs(before), isTrue);
      expect(sensor.receivedAt.isBefore(after) || sensor.receivedAt.isAtSameMomentAs(after), isTrue);
      expect(formatted, contains('${before.year}'));
      // Verify it does NOT contain 1970
      expect(formatted, isNot(contains('1970')));
    });

    test('receivedAt can be explicitly provided', () {
      // Arrange: provide a specific receivedAt
      final specificTime = DateTime(2025, 6, 15, 14, 30, 0);
      final sensor = SensorData(
        distance: 10.0,
        soilMoisture: 0,
        tiltX: 0,
        tiltY: 0,
        vibration: 0,
        timestamp: 31791,
        receivedAt: specificTime,
      );

      // Assert
      expect(sensor.receivedAt, specificTime);
      expect(sensor.formattedReceivedAt, '2025-06-15 14:30:00');
    });

    test('toString returns a meaningful string representation', () {
      // Arrange
      final sensor = SensorData(
        distance: 10.5,
        soilMoisture: 300.0,
        tiltX: 1.0,
        tiltY: -2.0,
        vibration: 5.0,
        timestamp: 1700000000000,
      );

      // Act
      final result = sensor.toString();

      // Assert: verify the string contains key field values
      expect(result, contains('distance: 10.5'));
      expect(result, contains('soilMoisture: 300.0'));
      expect(result, contains('vibration: 5.0'));
    });

    test('fromMap handles string numeric values', () {
      // Arrange: simulate data with string-encoded numbers
      final map = {
        'distance': '15.3',
        'soilMoisture': '200',
        'tiltX': '0.5',
        'tiltY': '-1.5',
        'vibration': '2.0',
        'timestamp': '1700000000000',
      };

      // Act
      final sensor = SensorData.fromMap(map);

      // Assert: string values are correctly parsed
      expect(sensor.distance, 15.3);
      expect(sensor.soilMoisture, 200.0);
      expect(sensor.tiltX, 0.5);
      expect(sensor.tiltY, -1.5);
      expect(sensor.vibration, 2.0);
      expect(sensor.timestamp, 1700000000000);
    });
  });
}
