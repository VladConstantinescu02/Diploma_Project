import 'package:flutter/material.dart';
import 'package:diploma_prj/shared/widgets/text_box_widget.dart';

// Your colors
const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

class ThreeTextBoxDialogBox extends StatefulWidget {
  final String title;
  final String label1;
  final String label2;
  final String label3;
  final IconData icon1;
  final IconData icon2;
  final IconData icon3;
  final Function(String, String, String) onSubmit;
  final Color buttonColor;
  final String buttonText;
  final Color buttonTextColor;
  final Color dialogBackgroundColor;

  const ThreeTextBoxDialogBox({
    super.key,
    required this.title,
    required this.label1,
    required this.label2,
    required this.label3,
    required this.icon1,
    required this.icon2,
    required this.icon3,
    required this.onSubmit,
    required this.buttonColor,
    required this.buttonText,
    required this.buttonTextColor,
    required this.dialogBackgroundColor,
  });

  @override
  State<ThreeTextBoxDialogBox> createState() => _ThreeTextBoxDialogBoxState();
}

class _ThreeTextBoxDialogBoxState extends State<ThreeTextBoxDialogBox> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyControllerTextbox(
            textBoxController: _controller1,
            textBoxLabel: widget.label1,
            textBoxIcon: widget.icon1,
            textLabelColor: darkColor,
            textBoxFocusedColor: mainColor,
            textBoxStaticColor: secondaryColor,
          ),
          const SizedBox(height: 12),
          MyControllerTextbox(
            textBoxController: _controller2,
            textBoxLabel: widget.label2,
            textBoxIcon: widget.icon2,
            textLabelColor: darkColor,
            textBoxFocusedColor: mainColor,
            textBoxStaticColor: secondaryColor,
          ),
          const SizedBox(height: 12),
          MyControllerTextbox(
            textBoxController: _controller3,
            textBoxLabel: widget.label3,
            textBoxIcon: widget.icon3,
            textLabelColor: darkColor,
            textBoxFocusedColor: mainColor,
            textBoxStaticColor: secondaryColor,
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: widget.buttonColor
          ),
          onPressed: () {
            final input1 = _controller1.text.trim();
            final input2 = _controller2.text.trim();
            final input3 = _controller3.text.trim();
            widget.onSubmit(input1, input2, input3);
            Navigator.of(context).pop();
          },
          child: Text(
              widget.buttonText,
            style: TextStyle(
              color: widget.buttonTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
