import 'dart:convert';

import 'package:weather_app/data/data_provider/weather_data_provider.dart';
import 'package:weather_app/model/wether_model.dart';

class WeatherRepository {
  WeatherDataProvider weatherDataProvider;
  WeatherRepository(this.weatherDataProvider);

  Future<WeatherModel> getWeatherDetails(String city) async {
    try {
      final weatherData = await weatherDataProvider.getWeatherDetails(city);
      final data = await jsonDecode(weatherData);
      if (data['cod'] == '404') {
        throw data['message'];
      }
      if (data['cod'] != '200') {
        throw 'Unexpected Error Occurred!';
      }

      return WeatherModel.fromMap(data);
    } catch (e) {
      throw e.toString();
    }
  }
}
