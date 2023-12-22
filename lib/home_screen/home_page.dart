import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:intl/intl.dart";
import 'package:weather_app/bloc/weather_bloc.dart';
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
    context.read<WeatherBloc>().add(WeatherFetched());
  }

  final TextEditingController _inputController = TextEditingController();

  void searchBtnHandler(String search) {
    if (search.isEmpty) {
      return;
    }
    context.read<WeatherBloc>().add(WeatherLocationInput(search));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      if (state is WeatherFailure) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                state.error.toString(),
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
                  context.read<WeatherBloc>().add(WeatherFetched());
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
      if (state is! WeatherSuccess) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }

      final data = state.weatherModel;

      final currentTemperature = data.currentTemperature;

      final currentSky = data.currentSky;

      final IconData currentSkyIcon = data.currentSkyIcon;

      final currentHumidity = data.currentHumidity;

      final currentWindSpeed = data.currentWindSpeed;
      final currentPressure = data.currentPressure;
      final location = data.location;
      final weatherMap = data.weatherMap;
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  context.read<WeatherBloc>().add(WeatherFetched());
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
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                        borderSide: const BorderSide(color: Colors.white30),
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
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 18),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemperature°C",
                                style: const TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
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
                                    currentSky,
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
                      style: TextStyle(fontSize: 20, color: Colors.white70),
                    ),
                  ),
                ),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final time =
                          DateTime.parse(weatherMap[index + 1]['dt_txt']);

                      IconData icon = weatherMap[index + 1]['weather'][0]
                                      ['main']
                                  .toString()
                                  .toLowerCase() ==
                              'clouds'
                          ? Icons.cloud
                          : Icons.sunny;
                      var temperature =
                          "${(weatherMap[index + 1]['main']['temp'] - 273 as double).toStringAsFixed(2)}°C";

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
                      style: TextStyle(fontSize: 20, color: Colors.white70),
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
