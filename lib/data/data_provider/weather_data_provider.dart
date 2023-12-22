import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherDataProvider {
  Future<String> getWeatherDetails(String cityName) async {
    await dotenv.load(fileName: ".env");

    try {
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=${dotenv.env['WEATHER_SECRET_KEYS']}"),
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
