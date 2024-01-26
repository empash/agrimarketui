import 'dart:convert';

import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/providers/user.dart';
import 'package:agrimarket/screens/farmer_screen.dart';
import 'package:agrimarket/screens/register_screen.dart';
import 'package:agrimarket/screens/serviceprovider_screen.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:agrimarket/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final String userType;
  const LoginScreen({super.key, required this.userType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  void _toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _login(BuildContext context, User user) async {
    _toggleLoading(true);

    // Replace this with your authentication logic
    String email = _emailController.text;
    String password = _passwordController.text;

    var rawData = {
      "email": email,
      "password": password,
    };
    var url = Uri.https(Constants.rootUrl, '/api/v1/users/login');

    try {
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(rawData));

      bool success = false;
      if (response.statusCode == 200) {
        // success message
        success = true;
      }
      _toggleLoading(false);

      var result = jsonDecode(response.body);
      user.setUser = {
        'name': result['name'].toString(),
        'id': result['id'].toString(),
      };

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success ? 'Login Successfully' : 'Invalid Credentials'),
        ));
        if (!success) return;
        if (widget.userType.toLowerCase() == 'farmer') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FarmerScreen()));
        }

        if (widget.userType.toLowerCase() == 'service provider') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ServiceProviderScreen()));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error during login: $e'),
        ));
      }
      _toggleLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                  text: 'Login as ${Utils.capitalize(widget.userType)}',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _login(context, user),
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.lightBlue),
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const MyText(
                          text: 'Login',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                ),
              ),
              const SizedBox(height: 22.0),
              Row(
                children: [
                  const MyText(
                      text: 'Don\'t have an account.',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.blueGrey),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                                  userType: widget.userType,
                                )));
                      },
                      child: const MyText(
                          text: 'Register',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.lightBlue))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
