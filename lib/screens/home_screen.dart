import 'package:agrimarket/screens/farmer_screen.dart';
import 'package:agrimarket/screens/login_screen.dart';
import 'package:agrimarket/screens/serviceprovider_screen.dart';
import 'package:agrimarket/widgets/button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'AgriMarket',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            MyButton(
              text: 'Farmer',
              route: LoginScreen(userType: 'farmer'),
              // route: FarmerScreen(),
            ),
            SizedBox(
              height: 15,
            ),
            MyButton(
              text: 'Service Provider',
              route: LoginScreen(userType: 'service Provider'),
              // route: ServiceProviderScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
