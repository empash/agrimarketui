import 'dart:convert';

import 'package:agrimarket/providers/user.dart';
import 'package:agrimarket/screens/home_screen.dart';
import 'package:agrimarket/screens/serviceprovider_manage.dart';
import 'package:agrimarket/screens/serviceprovider_market.dart';
import 'package:agrimarket/screens/serviceprovider_reports.dart';
import 'package:agrimarket/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({super.key});

  @override
  State<ServiceProviderScreen> createState() => _ServiceProviderScreenState();
}

const list = ['services', 'market'];

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  String dropdownValue = list.first;

  String weatherDescription = 'Sunny';
  String temperature = '32';
  String location = 'Aambari, Urlabari';

  Future<void> _getCurrentLocationWeather() async {
    try {
      // Check if location services are enabled
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        // Location services are not enabled, ask the user to enable them
        await Geolocator.openLocationSettings();
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request location permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Handle case where location permission is denied
          _showErrorSnackBar('Location permission is denied');
          return;
        }
      }

      // Get user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Use the obtained latitude and longitude
      double latitude = position.latitude;
      double longitude = position.longitude;

      // API Key from OpenWeatherMap (sign up for a free account to get your API key)
      String apiKey = 'bb6a8d7456e24798a1df62d1b67d1205';

      // API endpoint for current weather data
      String apiUrl =
          'https://api.weatherbit.io/v2.0/current?lat=$latitude&lon=$longitude&key=$apiKey';

      // Make API request
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> weatherData = json.decode(response.body);

        setState(() {
          weatherDescription = weatherData['data'][0]['weather']['description'];
          temperature = weatherData['data'][0]['temp'].toString();
          location = weatherData['data'][0]['city_name'];
        });
      } else {
        _showErrorSnackBar('Failed to load weather data');
      }
    } catch (e) {
      _showErrorSnackBar('Error fetching weather data');
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

  IconData _getWeatherIcon() {
    switch (weatherDescription.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access; // Replace with a rain icon of your choice
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'moderate rain':
        return Icons
            .grain; // Replace with an appropriate icon for moderate rain
      // Add more cases for different weather conditions as needed
      default:
        return Icons
            .wb_sunny; // Default to a sunny icon if the weather condition is unknown
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 60,
                      ),
                      Text(
                        'Hello, ${user.getUser['name']}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        // remove user
                        user.removeUser();
                        // navigate
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 40,
                        color: Colors.blueGrey,
                      ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  border: Border.all(
                    color: Colors.black12,
                    width: .5,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weatherDescription,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        Text(
                          '$temperature°C',
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          location,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Icon(
                      _getWeatherIcon(), // You can replace this with your own logic to determine the weather icon
                      size: 50,
                      color: Colors.yellow,
                    ),
                    // Add a Refresh button
                    TextButton(
                      onPressed: () {
                        _getCurrentLocationWeather();
                      },
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ServiceProviderManage()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.note,
                        size: 40,
                      ),
                      MyText(
                          text: 'Manage Service Requests',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ServiceProviderMarket()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.shopify,
                        size: 40,
                      ),
                      MyText(
                          text: 'Manage Market Requests',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ServiceProviderReport()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.note_alt,
                        size: 40,
                      ),
                      MyText(
                          text: 'Manage Reports',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              /*  GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          surfaceTintColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 350,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const MyText(
                                        text: 'Create Request',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    const SizedBox(
                                      width: 200,
                                      child: TextField(
                                        decoration: InputDecoration(
                                            hintText: 'Enter Service Name'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      width: 200,
                                      child: TextField(
                                        decoration: InputDecoration(
                                            hintText: 'Enter Rate/Price'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      width: 200,
                                      child: TextField(
                                        decoration: InputDecoration(
                                            hintText: 'Enter Location'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const MyText(
                                              text: 'Select Type',
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black),
                                          DropdownButton(
                                            value: dropdownValue,
                                            items: list
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                    Utils.capitalize(value)),
                                              );
                                            }).toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                dropdownValue = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const ElevatedButton(
                                      onPressed: null,
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.lightBlue),
                                      ),
                                      child: MyText(
                                          text: 'Create',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.add,
                        size: 40,
                      ),
                      MyText(
                          text: 'Create Requests',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
