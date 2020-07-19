import 'package:flutter/cupertino.dart';
import 'package:unified_reminder/styles/colors.dart';

class DropDownSingleItem extends StatelessWidget {
  final String label;

  const DropDownSingleItem({@required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: textboxColor, borderRadius: BorderRadius.circular(10)),
      child: Text(
        label,
        style: TextStyle(
          color: whiteColor,
          fontSize: 15,
        ),
      ),
    );
  }
}
