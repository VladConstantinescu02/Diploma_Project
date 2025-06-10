import 'package:diploma_prj/shared/widgets/text_box_widget.dart';
import 'package:flutter/material.dart';

void showMyDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter Your Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyControllerTextbox(
              textBoxController: emailController,
              textBoxLabel: 'Email',
              textBoxIcon: Icons.email_outlined,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              final enteredText = emailController.text;
              // Do something with the text
              Navigator.of(context).pop();
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
