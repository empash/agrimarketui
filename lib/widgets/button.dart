import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Widget route;

  const MyButton({super.key, required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 15)),
        backgroundColor: MaterialStatePropertyAll(Colors.lightBlue),
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => route)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 15,
          ),
        ],
      ),
    );
  }
}
