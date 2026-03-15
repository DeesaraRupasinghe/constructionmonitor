import 'package:flutter/material.dart';

/// A reusable card widget that displays a single sensor value.
///
/// Shows an [icon], a [label] describing the sensor, and its current
/// [value] in a styled Material card with rounded corners and elevation.
class SensorCard extends StatelessWidget {
  /// The icon displayed at the top of the card.
  final IconData icon;

  /// The label text describing the sensor (e.g., "Distance").
  final String label;

  /// The formatted sensor value to display.
  final String value;

  /// The color used for the icon and label.
  final Color color;

  /// Creates a [SensorCard] widget.
  const SensorCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sensor icon with colored circle background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),

            // Sensor label text
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Sensor value text (large and bold)
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
