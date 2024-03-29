import 'dart:convert';

import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/constants/styles.dart';
import 'package:agrimarket/providers/user.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:agrimarket/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FarmerMarketplace extends StatefulWidget {
  const FarmerMarketplace({super.key});

  @override
  State<FarmerMarketplace> createState() => _FarmerMarketplaceState();
}

const list = ['kg', 'ton', 'quintel'];

class _FarmerMarketplaceState extends State<FarmerMarketplace> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String dropdownValue = list.first;

  List marketsList = [];

  bool isLoading = false;
  bool isCreating = false;

  void _toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void _toggleCreating(bool value) {
    setState(() {
      isCreating = value;
    });
  }

  Future<List> getmarketList(String id) async {
    var url = Uri.https(Constants.rootUrl, '/api/v1/user/$id/markets');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load markets');
    }
  }

  void createSales(String id) async {
    _toggleCreating(true);

    String productName = _productNameController.text;
    String quantity = _quantityController.text;
    String location = _locationController.text;

    var url = Uri.https(Constants.rootUrl, '/api/v1/user/$id/markets');

    var rawData = {
      "productName": productName,
      "qty": quantity,
      "location": location,
    };

    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(rawData));

    bool success = false;
    if (response.statusCode == 201) {
      success = true;
    }
    _toggleCreating(false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success
              ? 'Sales Created Successfully'
              : 'Something went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    return FutureBuilder(
        future: getmarketList(user.getUser['id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading data'),
            );
          } else {
            // Use marketsList from the snapshot.data
            List marketsList = snapshot.data as List;

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  if (marketsList.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article, // Replace with your desired icon
                          size: 100.0,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'No Sales Yet',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'It seems there are no sales to display at the moment. Why not create a new sales and request your needs?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ListView.builder(
                      itemCount: marketsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          margin: const EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Utils.capitalize(
                                        marketsList[index]['productName']),
                                    style: Styles.secondaryHeader,
                                  ),
                                  const Text(
                                    'Rate: Rs.100/kg',
                                    style: Styles.smallGrey,
                                  ),
                                  Text(
                                    'Quantity: ${marketsList[index]['qty']}',
                                    style: Styles.smallHighlight,
                                  ),
                                  Text(
                                    'Location: ${marketsList[index]['location']}',
                                    style: Styles.smallHighlight,
                                  ),
                                ],
                              ),
                              // ElevatedButton(
                              //   onPressed: () => _handleSell(context),
                              //   style: const ButtonStyle(
                              //     backgroundColor:
                              //         MaterialStatePropertyAll(Colors.lightBlue),
                              //   ),
                              //   child: const Text(
                              //     'Sell',
                              //     style: TextStyle(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
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
                                                SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    controller:
                                                        _productNameController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Enter Product Name'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    controller:
                                                        _locationController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Enter Location'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: TextField(
                                                    controller:
                                                        _quantityController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Enter Quantity'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const MyText(
                                                          text: 'Select Type',
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: Colors.black),
                                                      DropdownButton(
                                                        value: dropdownValue,
                                                        items: list.map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(Utils
                                                                .capitalize(
                                                                    value)),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            dropdownValue =
                                                                value!;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // create data here
                                                    createSales(
                                                        user.getUser['id']);

                                                    Navigator.of(context).pop();
                                                    // refresh the original list
                                                    getmarketList(
                                                        user.getUser['id']);
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.lightBlue),
                                                  ),
                                                  child: const MyText(
                                                      text: 'Create',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.add_circle,
                          size: 40,
                          color: Colors.lightBlue,
                        )),
                  ),
                ],
              ),
            );
          }
        });
  }
}
