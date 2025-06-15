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
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: [
        TextButton(
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
