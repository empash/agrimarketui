import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/constants/styles.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:flutter/material.dart';

class FarmerManageService extends StatefulWidget {
  const FarmerManageService({super.key});

  @override
  State<FarmerManageService> createState() => _FarmerManageServiceState();
}

class _FarmerManageServiceState extends State<FarmerManageService> {
  String _serviceType = Constants.serviceStatus.first;

  void _toggleServiceType(String value) {
    setState(() {
      _serviceType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color statusColors = Colors.lightGreen;

    if (_serviceType == 'cancelled') {
      statusColors = Colors.red;
    }

    if (_serviceType == 'operating') {
      statusColors = Colors.orange;
    }

    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text('Manage Services'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30,
              child: ListView.builder(
                itemCount: Constants.serviceStatus.length,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final serviceText = Constants.serviceStatus[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector(
                      onTap: () => _toggleServiceType(serviceText),
                      child: Text(
                        Utils.capitalize(Constants.serviceStatus[index]),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: serviceText == _serviceType
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: serviceText == _serviceType
                              ? Colors.black
                              : Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                padding: const EdgeInsets.all(10),
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 8.0);
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hire Workers',
                          style: Styles.primaryHeader,
                        ),
                        Row(
                          children: [
                            Text(
                              'Type: Workers',
                              style: Styles.smallGrey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Rate: Rs.100/hr',
                              style: Styles.smallGrey,
                            ),
                          ],
                        ),
                        Text(
                          'Hired Date: 2024/01/11',
                          style: Styles.smallGrey,
                        ),
                        // SizedBox(
                        //   width: 100,
                        //   child: ElevatedButton(
                        //     onPressed: null,
                        //     style: ButtonStyle(
                        //         backgroundColor:
                        //             MaterialStatePropertyAll(statusColors)),
                        //     child: Text(
                        //       Utils.capitalize(_serviceType),
                        //       style: const TextStyle(
                        //           color: Colors.white,
                        //           fontWeight: FontWeight.bold),
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
        ));
  }
}
