import 'dart:convert';

import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:agrimarket/widgets/text.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  final String userType;
  const RegisterScreen({super.key, required this.userType});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _municipalityController = TextEditingController();
  final TextEditingController _toleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  void _toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _register(BuildContext context) async {
    _toggleLoading(true);

    String userType = widget.userType;
    String name = _fullnameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String municipilty = _municipalityController.text;
    String tole = _toleController.text;

    if (userType == 'service provider') {
      userType = 'servicerequest';
    }

    var url = Uri.https(Constants.rootUrl, '/api/v1/users/');
    var rawData = {
      "name": name,
      "email": email,
      "password": password,
      "userType": userType,
      "municipilty": municipilty,
      "tole": tole
    };
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(rawData));
    bool success = false;
    if (response.statusCode == 201) {
      // success message
      success = true;
    }

    _toggleLoading(false);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(success ? 'Registered Successfully' : 'Something went wrong'),
      ));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoginScreen(
                userType: widget.userType,
              )));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullnameController.dispose();
    _passwordController.dispose();
    _toleController.dispose();
    _municipalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                    text: 'Register as ${Utils.capitalize(widget.userType)}',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                TextField(
                  controller: _fullnameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _municipalityController,
                  decoration: const InputDecoration(
                    labelText: 'Municipality',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _toleController,
                  decoration: const InputDecoration(
                    labelText: 'Tole',
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
                    onPressed: () => _register(context),
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.lightBlue),
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const MyText(
                            text: 'Register',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                  ),
                ),
                const SizedBox(height: 22.0),
                Row(
                  children: [
                    const MyText(
                        text: 'Already have an account.',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.blueGrey),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreen(userType: widget.userType)));
                        },
                        child: const MyText(
                            text: 'Login',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
