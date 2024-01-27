import 'dart:convert';

import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/constants/styles.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceProviderReport extends StatefulWidget {
  const ServiceProviderReport({Key? key}) : super(key: key);

  @override
  State<ServiceProviderReport> createState() => _ServiceProviderReportState();
}

class _ServiceProviderReportState extends State<ServiceProviderReport> {
  List servicesList = [];

  bool isLoading = false;

  String dropdownValue = Constants.servicesList.first;

  void _toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void getServiceList() async {
    _toggleLoading(true);

    var url = Uri.https(Constants.rootUrl, '/api/v1/reports');

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
    super.initState();
    getServiceList();
  }

  @override
  Widget build(BuildContext context) {
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
