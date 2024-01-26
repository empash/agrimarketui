import 'dart:convert';

import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/constants/styles.dart';
import 'package:agrimarket/providers/user.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FarmerReports extends StatefulWidget {
  const FarmerReports({Key? key}) : super(key: key);

  @override
  State<FarmerReports> createState() => _FarmerReportsState();
}

class _FarmerReportsState extends State<FarmerReports> {
  List servicesList = [];

  bool isLoading = false;

  String dropdownValue = Constants.servicesList.first;

  void _toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void getServiceList(String id) async {
    _toggleLoading(true);

    var url = Uri.https(Constants.rootUrl, '/api/v1/user/$id/reports');

    var response = await http.get(url);
    // if (response.statusCode == 200) {
    // success message
    // success = true;
    // }

    setState(() {
      servicesList = jsonDecode(response.body);
    });

    _toggleLoading(false);
  }

  @override
  void initState() {
    User user = Provider.of<User>(context, listen: false);

    super.initState();
    getServiceList(user.getUser['id']);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reports'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: servicesList.length,
              padding: const EdgeInsets.all(10),
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8.0);
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report ID: ${Utils.capitalize(servicesList[index]['rid'].toString())}',
                        style: Styles.primaryHeader,
                      ),
                      const Text(
                        'Problem:',
                        style: Styles.smallHighlight,
                      ),
                      Text(
                        servicesList[index]['problem'],
                        style: Styles.smallGrey,
                      ),
                      Text(
                        'Phonenumber: ${servicesList[index]['phone']}',
                        style: Styles.smallGrey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
