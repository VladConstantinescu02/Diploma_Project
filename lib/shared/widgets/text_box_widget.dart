import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyControllerTextbox extends StatelessWidget {
  final TextEditingController textBoxController;
  final String textBoxLabel;
  final IconData textBoxIcon;
  final Color textLabelColor;
  final Color textBoxFocusedColor;
  final Color textBoxStaticColor;

  const MyControllerTextbox(
      {super.key,
      required this.textBoxController,
      required this.textBoxLabel,
      required this.textBoxIcon,
      required this.textLabelColor,
      required this.textBoxFocusedColor,
      required this.textBoxStaticColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: kIsWeb
          ? const EdgeInsets.symmetric(horizontal: 350)
          : const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: textBoxController,
        decoration: InputDecoration(
          labelText: textBoxLabel,
          labelStyle: TextStyle(
            color: textLabelColor, // label color
            fontWeight: FontWeight.bold, // make it bold
            fontSize: 16, // font size
          ),
          prefixIcon: Icon(textBoxIcon),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: textBoxFocusedColor, width: 2.0),
            borderRadius: BorderRadius.circular(48.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textBoxStaticColor, width: 2.0),
            borderRadius: BorderRadius.circular(48.0),
          ),
        ),
      ),
    );
  }
}
