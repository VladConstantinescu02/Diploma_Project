import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyControllerTextbox extends StatelessWidget {
  final TextEditingController textBoxController;
  final String textBoxLabel;
  final IconData textBoxIcon;

  const MyControllerTextbox({
    super.key,
    required this.textBoxController,
    required this.textBoxLabel,
    required this.textBoxIcon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: kIsWeb
          ? const EdgeInsets.symmetric(horizontal: 350)
          : const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: textBoxController,
        decoration: InputDecoration(
          labelText: textBoxLabel,
          prefixIcon: Icon(textBoxIcon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}