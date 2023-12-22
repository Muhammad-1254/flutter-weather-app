part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

final class WeatherFetched extends WeatherEvent {}

final class WeatherLocationInput extends WeatherEvent {
  final String _location;
  WeatherLocationInput(this._location);
  String get getLocation {
    return _location;
  }
}
