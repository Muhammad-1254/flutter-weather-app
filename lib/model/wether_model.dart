import 'package:flutter/material.dart';

class WeatherModel {
  final String currentTemperature;
  final String currentSky;
  final String location;
  final String currentHumidity;
  final String currentWindSpeed;
  final String currentPressure;
  final IconData currentSkyIcon;
  final List<dynamic> weatherMap;

  WeatherModel({
    required this.currentHumidity,
    required this.currentPressure,
    required this.currentSky,
    required this.currentTemperature,
    required this.currentWindSpeed,
    required this.location,
    required this.currentSkyIcon,
    required this.weatherMap,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> data) {
    return WeatherModel(
      currentTemperature: ((data['list'][0]['main']['temp'] - 273.00) as double)
          .toStringAsFixed(2),
      currentSky: data['list'][0]['weather'][0]['main'],
      location: "${data['city']['name']}, ${data['city']['country']}",
      currentWindSpeed: data['list'][0]['wind']['speed'].toString(),
      currentPressure: data['list'][0]['main']['humidity'].toString(),
      currentHumidity: data['list'][0]['main']['pressure'].toString(),
      weatherMap: data['list'],
      currentSkyIcon:
          data['list'][0]['weather'][0]['main'].toString().toLowerCase() ==
                  'clouds'
              ? Icons.cloud
              : Icons.sunny,
    );
  }
}
