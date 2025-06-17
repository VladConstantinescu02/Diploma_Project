import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TemplateObscuredTextbox extends StatefulWidget {
  final TextEditingController textBoxController;
  final String textBoxLabel;
  final IconData textBoxIcon;
  final Color textLabelColor;
  final Color textBoxFocusedColor;
  final Color textBoxStaticColor;
  final bool isInput;

  const TemplateObscuredTextbox({
    super.key,
    required this.textBoxController,
    required this.textBoxLabel,
    required this.textBoxIcon,
    required this.textLabelColor,
    required this.textBoxFocusedColor,
    required this.textBoxStaticColor,
    this.isInput = false,
  });

  @override
  TemplateObscuredTextboxState createState() => TemplateObscuredTextboxState();
}

class TemplateObscuredTextboxState extends State<TemplateObscuredTextbox> {
  bool inputVisible = false;

  @override
  void initState() {
    super.initState();
    inputVisible = !widget.isInput;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: kIsWeb
          ? const EdgeInsets.symmetric(horizontal: 350)
          : const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: widget.textBoxController,
        obscureText: !inputVisible,
        decoration: InputDecoration(
          labelText: widget.textBoxLabel,
          labelStyle: TextStyle(
            color: widget.textLabelColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          prefixIcon: Icon(widget.textBoxIcon),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.textBoxFocusedColor, width: 2.0),
            borderRadius: BorderRadius.circular(48.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.textBoxStaticColor, width: 2.0),
            borderRadius: BorderRadius.circular(48.0),
          ),
          suffixIcon: widget.isInput
              ? IconButton(
            icon: Icon(inputVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                inputVisible = !inputVisible;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
