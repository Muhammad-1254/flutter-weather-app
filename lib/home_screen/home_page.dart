// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import "package:intl/intl.dart";
import 'package:weather_app/home_screen/additional_information_items.dart';
import 'package:weather_app/home_screen/weather_forecast_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> weatherDetails;

  @override
  void initState() {
    super.initState();
    weatherDetails = getWeatherDetails("Karachi");
  }

  Future<Map<String, dynamic>> getWeatherDetails(String city) async {
    await dotenv.load(fileName: ".env");

    try {
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=${dotenv.env['WEATHER_SECRET_KEYS']}"),
      );
      final data = jsonDecode(res.body);
      if (kDebugMode) {
        print("response data: $data");
      }
      if (data['cod'] == '404') {
        throw data['message'];
      }
      if (data['cod'] != '200') {
        throw 'Unexpected Error Occurred!';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  final TextEditingController _inputController = TextEditingController();

  void searchBtnHandler(String search) {
    if (search.isEmpty) {
      return;
    }
    setState(() {
      weatherDetails = getWeatherDetails(search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: weatherDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                        decorationStyle: TextDecorationStyle.solid,
                        decorationColor: Colors.black,
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        weatherDetails = getWeatherDetails('Karachi');
                      });
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor)),
                      ),
                    ),
                    child: const Text(
                      "Go back!",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.data!;

          final currentTemperature =
              ((data['list'][0]['main']['temp'] - 273.00) as double)
                  .toStringAsFixed(2);
          final currentSky = data['list'][0]['weather'][0]['main'];
          final location =
              "${data['city']['name']}, ${data['city']['country']}";
          final IconData currentSkyIcon =
              currentSky.toString().toLowerCase() == 'clouds'
                  ? Icons.cloud
                  : Icons.sunny;
          final currentHumidity =
              data['list'][0]['main']['pressure'].toString();
          final currentWindSpeed = data['list'][0]['wind']['speed'].toString();
          final currentPressure =
              data['list'][0]['main']['humidity'].toString();
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      final city = _inputController.text.isEmpty
                          ? "Karachi"
                          : _inputController.text.split(' ')[0];
                      setState(() {
                        weatherDetails = getWeatherDetails(city);
                      });
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 34,
                    ),
                  )
                ],
                title: const Text(
                  "Weather App",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        TextField(
                          controller: _inputController,
                          autocorrect: true,
                          decoration: InputDecoration(
                            labelText: "Enter City here!",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                onPressed: () {
                                  searchBtnHandler(_inputController.text);
                                  _inputController.text = '';
                                },
                                icon: const Icon(Icons.search, size: 32),
                              ),
                            ),
                            labelStyle: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w200),
                            fillColor: Colors.white10,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white30),
                                borderRadius: BorderRadius.circular(
                                  16,
                                )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 18),
                                  child: Column(
                                    children: [
                                      Text(
                                        "$currentTemperature°C",
                                        style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Icon(
                                        currentSkyIcon,
                                        size: 55,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            location,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w100,
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            "$currentSky",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w100,
                                                color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Weather Forecast

                        const Padding(
                          padding: EdgeInsets.only(top: 25, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Weather Forecast",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white70),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final time = DateTime.parse(
                                  data['list'][index + 1]['dt_txt']);

                              IconData icon = data['list'][index + 1]['weather']
                                              [0]['main']
                                          .toString()
                                          .toLowerCase() ==
                                      'clouds'
                                  ? Icons.cloud
                                  : Icons.sunny;
                              var temperature =
                                  "${(data['list'][index + 1]['main']['temp'] - 273 as double).toStringAsFixed(2)}°C";

                              return WeatherForecastItem(
                                time: DateFormat('j').format(time),
                                icon: icon,
                                temperature: temperature,
                              );
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 25, bottom: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Additional Information",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white70),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AdditionalInformationItems(
                                    icon: Icons.water_drop,
                                    information: "Humidity",
                                    value: currentHumidity),
                                AdditionalInformationItems(
                                    icon: Icons.wind_power,
                                    information: "Wind Speed",
                                    value: currentWindSpeed),
                                AdditionalInformationItems(
                                    icon: Icons.beach_access,
                                    information: "Pressure",
                                    value: currentPressure),
                              ]),
                        )
                      ]),
                ),
              ),
            ),
          );
        });
  }
}
