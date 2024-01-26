import 'dart:convert';

import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/constants/styles.dart';
import 'package:agrimarket/providers/user.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:agrimarket/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ServiceBook extends StatefulWidget {
  const ServiceBook({Key? key}) : super(key: key);

  @override
  State<ServiceBook> createState() => _ServiceBookState();
}

class _ServiceBookState extends State<ServiceBook> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _proposeController = TextEditingController();

  List servicesList = [];

  bool isLoading = false;
  bool isCreating = false;

  String dropdownValue = Constants.servicesList.first;

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

  // void _handleHire(BuildContext context) {
  //   bool successHire = false;
  //   // make request to backend
  //   if (true) {
  //     successHire = true;
  //   }
  //   // process it
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.white,
  //           surfaceTintColor: Colors.white,
  //           title: const Text('Hire Status'),
  //           content: SizedBox(
  //             height: 100,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 successHire
  //                     ? const Icon(
  //                         Icons.check_circle,
  //                         color: Colors.green,
  //                         size: 50,
  //                       )
  //                     : const Icon(
  //                         Icons.error,
  //                         color: Colors.red,
  //                         size: 50,
  //                       ),
  //                 Text(successHire
  //                     ? 'You have successfully hired'
  //                     : 'Hiring Failed'),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, 'Cancel'),
  //               child: const Text('Cancel'),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, 'OK'),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         );
  //       });
  // }

  void getServiceList(String id) async {
    _toggleLoading(true);

    var url =
        Uri.https(Constants.rootUrl, '/api/v1/user/$id/requestedservices');

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

  void createService(String id) async {
    _toggleCreating(true);
    String phone = _phoneController.text;
    String location = _locationController.text;
    String propose = _proposeController.text;

    var url = Uri.https(Constants.rootUrl, '/api/v1/user/$id/requestservices');

    var rawData = {
      "servicetype": dropdownValue,
      "location": location,
      "phone": phone,
      "propose": propose,
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

    print(response.body);

    _toggleCreating(false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success
              ? 'Service Created Successfully'
              : 'Something went wrong')));
    }
  }

  @override
  void initState() {
    User user = Provider.of<User>(context, listen: false);

    super.initState();
    getServiceList(user.getUser['id']);
  }

  @override
  void dispose() {
    super.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _proposeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [
        Column(
          children: [
            // SizedBox(
            //   height: 30,
            //   child: ListView.builder(
            //     itemCount: Constants.servicesList.length,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (BuildContext context, int index) {
            //       final serviceText = Constants.servicesList[index]['type'];
            //       return Container(
            //         padding: const EdgeInsets.symmetric(horizontal: 5),
            //         child: GestureDetector(
            //           onTap: () => _toggleServiceType(serviceText),
            //           child: Text(
            //             '${Constants.servicesList[index]['text']}',
            //             style: TextStyle(
            //               fontSize: 16,
            //               fontWeight: serviceText == _serviceType
            //                   ? FontWeight.bold
            //                   : FontWeight.normal,
            //               color: serviceText == _serviceType
            //                   ? Colors.black
            //                   : Colors.black54,
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: ListView.separated(
                itemCount: servicesList.length,
                padding: const EdgeInsets.all(10),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 8.0);
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils.capitalize(servicesList[index]['propose']),
                          style: Styles.primaryHeader,
                        ),
                        Text(
                          'Type: ${servicesList[index]['servicetype']}',
                          style: Styles.smallGrey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Location: ${servicesList[index]['location']}',
                          style: Styles.smallGrey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Date Created: ${servicesList[index]['addedDate']}',
                          style: Styles.smallGrey,
                        ),
                        // SizedBox(
                        //   width: 100,
                        //   child: ElevatedButton(
                        //     onPressed: () => _handleHire(context),
                        //     style: const ButtonStyle(
                        //         backgroundColor:
                        //             MaterialStatePropertyAll(Colors.lightBlue)),
                        //     child: const Text(
                        //       'Hire',
                        //       style: TextStyle(
                        //           color: Colors.white, fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
              onPressed: () {
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
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _proposeController,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter Service Name'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _phoneController,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter Phonenumber'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _locationController,
                                      decoration: const InputDecoration(
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
                                          items: Constants.servicesList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child:
                                                  Text(Utils.capitalize(value)),
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
                                  ElevatedButton(
                                    onPressed: () {
                                      // create data here
                                      createService(user.getUser['id']);
                                      Navigator.of(context).pop();
                                      // refresh the original list
                                      getServiceList(user.getUser['id']);
                                    },
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.lightBlue),
                                    ),
                                    child: isCreating
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : const MyText(
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
              icon: const Icon(
                Icons.add_circle,
                size: 40,
                color: Colors.lightBlue,
              )),
        ),
      ],
    );
  }
}
