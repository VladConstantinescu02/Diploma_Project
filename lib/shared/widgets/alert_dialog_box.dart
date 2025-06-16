import 'package:flutter/material.dart';

class TemplateDialogBox extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color textButtonColorCancel;
  final Color textButtonColorConfirm;
  final Color buttonCancel;
  final Color buttonConfirm;
  final Color backgroundColor;

  const TemplateDialogBox({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Cancel',
    this.confirmText = 'OK',
    this.onConfirm,
    this.onCancel,
    required this.textButtonColorCancel,
    required this.textButtonColorConfirm,
    required this.backgroundColor,
    required this.buttonCancel,
    required this.buttonConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: buttonCancel,
          ),
          onPressed: () {
            Navigator.pop(context);
            if (onCancel != null) onCancel!();
          },
          child: Text(
            cancelText,
            style: TextStyle(
              color: textButtonColorCancel,
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: buttonConfirm
          ),
          onPressed: () {
            Navigator.pop(context);
            if (onConfirm != null) onConfirm!();
          },
          child: Text(
            confirmText,
            style: TextStyle(
              color: textButtonColorConfirm,
            ),
          ),
        ),
      ],
    );
  }
}
