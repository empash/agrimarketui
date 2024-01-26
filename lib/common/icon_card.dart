import 'package:agrimarket/widgets/text.dart';
import 'package:flutter/material.dart';

class IconCard extends StatefulWidget {
  final IconData iconData;
  final String iconText;
  final Widget? navRoute;
  const IconCard(
      {super.key,
      required this.iconData,
      required this.iconText,
      required this.navRoute});

  @override
  State<IconCard> createState() => _IconCardState();
}

class _IconCardState extends State<IconCard> {
  void _handleClick(BuildContext context) {
    if (widget.navRoute != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => widget.navRoute!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleClick(context),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: .5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.iconData,
              size: 50,
              color: Colors.lightBlue,
            ),
            const SizedBox(
              height: 5,
            ),
            MyText(
                text: widget.iconText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey),
            const SizedBox(
              height: 5,
            ),
            const Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }
}
