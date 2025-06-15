import 'package:flutter/material.dart';
import 'package:diploma_prj/shared/widgets/text_box_widget.dart';

// Colors
const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

class TwoInputDialogBox extends StatefulWidget {
  final String title;
  final String label1;
  final String label2;
  final IconData icon1;
  final IconData icon2;
  final Function(String, String) onSubmit;

  const TwoInputDialogBox({
    super.key,
    required this.title,
    required this.label1,
    required this.label2,
    required this.icon1,
    required this.icon2,
    required this.onSubmit,
  });

  @override
  State<TwoInputDialogBox> createState() => _TwoInputDialogBoxState();
}

class _TwoInputDialogBoxState extends State<TwoInputDialogBox> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final input1 = _controller1.text.trim();
            final input2 = _controller2.text.trim();
            widget.onSubmit(input1, input2);
            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
