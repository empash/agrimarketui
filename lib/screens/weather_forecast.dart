import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherForecast extends StatefulWidget {
  const WeatherForecast({Key? key}) : super(key: key);

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  final String apiKey =
      'bb6a8d7456e24798a1df62d1b67d1205'; // Replace with your Weatherbit API key

  bool isLocationServiceEnabled = false;

  Future<void> _checkLocationServiceStatus() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      isLocationServiceEnabled = enabled;
    });
  }

  Future<List<Map<String, dynamic>>> _getWeeklyWeatherForecast() async {
    try {
      // Check if location services are enabled
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        // Location services are not enabled, show an error message
        _showErrorSnackBar('Please enable location services');
        return [];
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request location permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Handle case where location permission is denied
          _showErrorSnackBar('Location permission is denied');
          return [];
        }
      }

      // Get user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position?.latitude ?? 37.7749;
      double longitude = position?.longitude ?? -122.4194;

      // API endpoint for 7-day weather forecast
      String apiUrl =
          'https://api.weatherbit.io/v2.0/forecast/daily?lat=$latitude&lon=$longitude&key=$apiKey&days=7';

      // Make API request
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> weatherData = json.decode(response.body);
        // Extract and display the 7-day forecast
        List<dynamic> forecastData = weatherData['data'];
        List<Map<String, dynamic>> formattedData = [];

        for (var day in forecastData) {
          String date = day['datetime'];
          String description = day['weather']['description'];
          double temperature = day['temp'];

          formattedData.add({
            'date': date,
            'description': description,
            'temperature': temperature,
          });

          print('$date: $description, Temperature: $temperature°C');
        }

        return formattedData;
      } else {
        _showErrorSnackBar(
            'Failed to load weather data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _showErrorSnackBar('Error fetching weather data: $e');
      return [];
    }
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  IconData _getWeatherIcon(String weatherDescription) {
    String lowercaseDescription = weatherDescription.toLowerCase();

    if (lowercaseDescription.contains('clear') ||
        lowercaseDescription.contains('clear sky')) {
      return Icons.wb_sunny;
    } else if (lowercaseDescription.contains('few clouds')) {
      return Icons
          .cloud_queue; // You can replace with the appropriate icon for few clouds
    } else if (lowercaseDescription.contains('scattered clouds')) {
      return Icons
          .cloud_queue; // You can replace with the appropriate icon for scattered clouds
    } else if (lowercaseDescription.contains('clouds') ||
        lowercaseDescription.contains('overcast')) {
      return Icons.cloud;
    } else if (lowercaseDescription.contains('rain') ||
        lowercaseDescription.contains('drizzle') ||
        lowercaseDescription.contains('showers')) {
      return Icons.beach_access; // Replace with a rain icon of your choice
    } else if (lowercaseDescription.contains('thunderstorm')) {
      return Icons.flash_on;
    } else if (lowercaseDescription.contains('snow') ||
        lowercaseDescription.contains('sleet') ||
        lowercaseDescription.contains('hail')) {
      return Icons.ac_unit;
    } else if (lowercaseDescription.contains('mist') ||
        lowercaseDescription.contains('fog')) {
      return Icons.wb_cloudy;
    } else if (lowercaseDescription.contains('smoke') ||
        lowercaseDescription.contains('dust') ||
        lowercaseDescription.contains('sand') ||
        lowercaseDescription.contains('ash')) {
      return Icons.wb_incandescent;
    } else if (lowercaseDescription.contains('squalls')) {
      return Icons.wb_cloudy;
    } else if (lowercaseDescription.contains('tornado')) {
      return Icons.warning;
    } else {
      return Icons
          .wb_sunny; // Default to a sunny icon if the weather condition is unknown
    }
  }

  void _enableLocation() async {
    // Open location settings
    await Geolocator.openLocationSettings();
  }

  @override
  void initState() {
    super.initState();
    _checkLocationServiceStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        actions: [
          IconButton(
            onPressed: isLocationServiceEnabled ? null : _enableLocation,
            icon: isLocationServiceEnabled
                ? const Icon(Icons.location_off)
                : const Icon(Icons.location_on),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getWeeklyWeatherForecast(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> weatherData =
                snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: weatherData.length,
              itemBuilder: (context, index) {
                final day = weatherData[index];
                return ListTile(
                  leading: Icon(_getWeatherIcon(day['description'])),
                  title: Text(day['date']),
                  subtitle: Text(
                      '${day['description']}, Temperature: ${day['temperature']}°C'),
                );
              },
            );
          } else {
            // Handle the case where data is null or not available
            return const Center(child: Text('No weather data available'));
          }
        },
      ),
    );
  }
}
