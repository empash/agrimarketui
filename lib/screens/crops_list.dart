import 'package:agrimarket/constants/consts.dart';
import 'package:flutter/material.dart';

class CropsList extends StatefulWidget {
  const CropsList({Key? key}) : super(key: key);

  @override
  State<CropsList> createState() => _CropsListState();
}

class _CropsListState extends State<CropsList> {
  String selectedMonth = Constants.months.first;

  @override
  Widget build(BuildContext context) {
    List<String> recommendedCrops = Constants.monthlyCrops[selectedMonth] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crops List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select a Month:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            MonthSelector(
              months: Constants.months,
              selectedMonth: selectedMonth,
              onMonthChanged: (String? month) {
                if (month != null) {
                  setState(() {
                    selectedMonth = month;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Recommended Crops:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CropList(crops: recommendedCrops),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthSelector extends StatelessWidget {
  final List<String> months;
  final String selectedMonth;
  final Function(String?) onMonthChanged;

  const MonthSelector({
    Key? key,
    required this.months,
    required this.selectedMonth,
    required this.onMonthChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedMonth,
      onChanged: onMonthChanged,
      items: months.map((month) {
        return DropdownMenuItem<String>(
          value: month,
          child: Text(month),
        );
      }).toList(),
    );
  }
}

class CropList extends StatelessWidget {
  final List<String> crops;

  const CropList({Key? key, required this.crops}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: crops.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(crops[index]),
          ),
        );
      },
    );
  }
}
