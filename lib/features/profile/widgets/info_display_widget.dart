
import 'package:diploma_prj/features/profile/widgets/info_widget.dart';
import 'package:flutter/cupertino.dart';

class MyInfo extends StatelessWidget {
  final String titleText;
  final String infoText;

  const MyInfo({
    super.key,
    required this.infoText,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return Info(
        infoKey: titleText,
        info: infoText);
  }
}

