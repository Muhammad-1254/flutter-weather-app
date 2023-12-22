import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/model/wether_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(
    this.weatherRepository,
  ) : super(WeatherInitial()) {
    on<WeatherFetched>(_getCurrentWeather);

    on<WeatherLocationInput>(_getCurrentWeatherByInput);
  }

  void _getCurrentWeather(
      WeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());

    try {
      final weather = await weatherRepository.getWeatherDetails("karachi");
      emit(WeatherSuccess(weather));
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }

  void _getCurrentWeatherByInput(
      WeatherEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());

    try {
      if (event is WeatherLocationInput) {
        final weather =
            await weatherRepository.getWeatherDetails(event.getLocation);
        emit(WeatherSuccess(weather));
        return;
      }
      throw "Input the City or Country name!";
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }
}
