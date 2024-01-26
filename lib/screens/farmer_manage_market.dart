import 'package:agrimarket/constants/consts.dart';
import 'package:agrimarket/constants/styles.dart';
import 'package:agrimarket/utils/utils.dart';
import 'package:flutter/material.dart';

class FarmerManageMarket extends StatefulWidget {
  const FarmerManageMarket({super.key});

  @override
  State<FarmerManageMarket> createState() => _FarmerManageMarketState();
}

class _FarmerManageMarketState extends State<FarmerManageMarket> {
  String _salesType = Constants.salesStatus.first;

  void _togglesalesType(String value) {
    setState(() {
      _salesType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color statusColors = Colors.lightGreen;

    if (_salesType == 'cancelled') {
      statusColors = Colors.red;
    }

    if (_salesType == 'waiting') {
      statusColors = Colors.orange;
    }
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text('Manage Sales'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30,
              child: ListView.builder(
                itemCount: Constants.salesStatus.length,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final salesText = Constants.salesStatus[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector(
                      onTap: () => _togglesalesType(salesText),
                      child: Text(
                        Utils.capitalize(Constants.salesStatus[index]),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: salesText == _salesType
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: salesText == _salesType
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
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/hire-workers.jpeg',
                            width: 120,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rice',
                                style: Styles.secondaryHeader,
                              ),
                              Text(
                                'Rate: Rs.100/kg',
                                style: Styles.smallGrey,
                              ),
                              Text(
                                'Dealer: ABC Dealer',
                                style: Styles.smallHighlight,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
