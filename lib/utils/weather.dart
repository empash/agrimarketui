// weather_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherApi(this.apiKey);

  Future<Map<String, dynamic>> getWeather(
      double latitude, double longitude) async {
    var baseUrl =
        Uri.https('', '/weather?lat=$latitude&lon=$longitude&appid=$apiKey');
    final response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
