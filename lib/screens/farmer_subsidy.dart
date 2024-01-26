import 'package:agrimarket/constants/styles.dart';
import 'package:flutter/material.dart';

class FarmerSubsidy extends StatefulWidget {
  const FarmerSubsidy({super.key});

  @override
  State<FarmerSubsidy> createState() => _FarmerSubsidyState();
}

class _FarmerSubsidyState extends State<FarmerSubsidy> {
  void _handleTap(BuildContext context) {
    bool successHire = false;
    // make request to backend
    if (true) {
      successHire = true;
    }
    // process it
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text('Apply Subsidy'),
            content: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  successHire
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 50,
                        )
                      : const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        ),
                  Text(successHire
                      ? 'You have successfully applied'
                      : 'Applying Failed'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: 15,
        padding: const EdgeInsets.all(10),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 8.0);
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thresher',
                      style: Styles.primaryHeader,
                    ),
                    Text(
                      'Type: Machines',
                      style: Styles.smallGrey,
                    ),
                    Text(
                      'Price: Rs.10000',
                      style: Styles.smallGrey,
                    ),
                    Text(
                      'Location: ABC Street, Koshi',
                      style: Styles.smallGrey,
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () => _handleTap(context),
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.lightGreen)),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
