import 'package:flutter/material.dart';

class WeatherForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;

  const WeatherForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      child: SizedBox(
        width: 100,
        height: 125,
        // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Icon(icon, size: 32),
          const SizedBox(
            height: 12,
          ),
          Text(
            temperature,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w100,
            ),
          )
        ]),
      ),
    );
  }
}
