import 'package:flutter/material.dart';
import 'package:diploma_prj/shared/widgets/text_box_widget.dart';

const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

class OneTextBoxDialogBox extends StatefulWidget {
  final String title;
  final String label;
  final IconData icon;
  final Function(String) onSubmit;
  final Color buttonColor;
  final String buttonText;
  final Color buttonTextColor;
  final Color dialogBackgroundColor;

  const OneTextBoxDialogBox({
    super.key,
    required this.title,
    required this.label,
    required this.icon,
    required this.onSubmit,
    required this.buttonColor,
    required this.buttonText,
    required this.buttonTextColor,
    required this.dialogBackgroundColor,
  });

  @override
  State<OneTextBoxDialogBox> createState() => _OneTextBoxDialogBoxState();
}

class _OneTextBoxDialogBoxState extends State<OneTextBoxDialogBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      backgroundColor: widget.dialogBackgroundColor,
      content: TemplateControllerTextbox(
        textBoxController: _controller,
        textBoxLabel: widget.label,
        textBoxIcon: widget.icon,
        textLabelColor: darkColor,
        textBoxFocusedColor: mainColor,
        textBoxStaticColor: secondaryColor,
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: widget.buttonColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            final input = _controller.text.trim();
            widget.onSubmit(input);
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
