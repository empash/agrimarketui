import 'dart:convert';

import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/providers/user.dart';
import 'package:agrimarket/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool isLoading = false;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _createReport(String id) async {
    _toggleLoading(true);

    String phone = _phoneController.text;
    String message = _messageController.text;

    var rawData = {
      "phone": phone,
      "problem": message,
    };
    var url = Uri.https(Constants.rootUrl, '/api/v1/user/$id/reports');

    try {
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
          content: Text(
              success ? 'Report Created Successfully' : 'Something went wrong'),
        ));
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
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Report a Problem'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MyText(
                  text:
                      'We will help you as soon as you describe your problem. Please don\'t hesitate to submit your problem.',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
              const SizedBox(
                height: 15,
              ),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Enter you full name',
              //   ),
              // ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phonenumber',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                maxLines: 5,
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Report Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 150,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _createReport(user.getUser['id']),
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.lightBlue)),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const MyText(
                          text: 'Submit',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
