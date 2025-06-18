import 'package:flutter/cupertino.dart';

//Class whose purpose is to model a set of parameters for a list of navigation items
class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  //parameters that must appear for every item of the list
  const NavigationItem({
    required this.icon,
    required this.label,
    required this.route
  });
}