import 'dart:convert';

import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/constants/styles.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:agrimarket/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceProviderMarket extends StatefulWidget {
  const ServiceProviderMarket({super.key});

  @override
  State<ServiceProviderMarket> createState() => _ServiceProviderMarketState();
}

class _ServiceProviderMarketState extends State<ServiceProviderMarket> {
  List servicesList = [];

  bool isLoading = false;

  void _toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void getServiceList() async {
    _toggleLoading(true);

    var url = Uri.https(Constants.rootUrl, '/api/v1/user/1/markets');

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
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Manage Markets'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                  itemCount: servicesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black12,
                        width: .5,
                      )),
                      child: GestureDetector(
                          onTap: null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                  text: Utils.capitalize(
                                      servicesList[index]['productName']),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                              Text(
                                'Quantity: ${Utils.capitalize(servicesList[index]['qty'])}',
                                style: Styles.smallGrey,
                              ),
                              Text(
                                'Location: ${servicesList[index]['location']}',
                                style: Styles.smallGrey,
                              ),
                              // Text(
                              //   'Phone: ${servicesList[index]['phone']}',
                              //   style: Styles.smallGrey,
                              // ),
                              // MyText(
                              //     text:
                              //         'Date Created: ${servicesList[index]['addedDate']}',
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.normal,
                              //     color: Colors.black),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: null,
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green),
                                    ),
                                    child: MyText(
                                        text: 'Accept',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: null,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red),
                                    ),
                                    child: MyText(
                                        text: 'Reject',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          )),
                    );
                  }),
            ),
    );
  }
}