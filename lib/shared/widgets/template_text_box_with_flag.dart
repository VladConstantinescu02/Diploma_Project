import 'package:flutter/material.dart';

class TemplateTextBoxWithFlag extends StatefulWidget {
  const TemplateTextBoxWithFlag({
    super.key,
    required this.textBoxLabel,
    required this.textBoxIcon,
    required this.textLabelColor,
    required this.textBoxFocusedColor,
    required this.textBoxStaticColor,
    this.onValidate,
    required this.textBoxController, // Accept external controller
  });

  final String textBoxLabel;
  final IconData textBoxIcon;
  final Color textLabelColor;
  final Color textBoxFocusedColor;
  final Color textBoxStaticColor;
  final String? Function(String)? onValidate; // Validation callback
  final TextEditingController textBoxController;

  @override
  State<TemplateTextBoxWithFlag> createState() =>
      _TemplateTextBoxWithFlagState();
}

class _TemplateTextBoxWithFlagState extends State<TemplateTextBoxWithFlag> {
  String? _errorText; // Error message state

  void _validate() {
    if (widget.onValidate != null) {
      setState(() {
        _errorText = widget.onValidate!(widget.textBoxController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textBoxController, // Use the provided controller
      decoration: InputDecoration(
        labelText: widget.textBoxLabel,
        labelStyle: TextStyle(
          color: widget.textLabelColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        prefixIcon: Icon(widget.textBoxIcon),
        errorText: _errorText, // Display the validation error
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.textBoxStaticColor, width: 2.0),
          borderRadius: BorderRadius.circular(48.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.textBoxFocusedColor, width: 2.0),
          borderRadius: BorderRadius.circular(48.0),
        ),
      ),
      onChanged: (text) => _validate(), // Trigger validation on text change
    );
  }
}
