 import 'package:flutter/material.dart';
import '../models/navigation_item_prototype.dart';


// list of navigation parameters
final List<NavigationItem> navigationItems = [
  const NavigationItem(icon: Icons.home_filled, label: 'Home', route: '/home'),
  const NavigationItem(icon: Icons.set_meal, label: 'Your Meals', route: '/meals'),
  const NavigationItem(icon: Icons.fastfood_rounded, label: 'fridge', route: '/fridge'),
  const NavigationItem(icon: Icons.account_circle_rounded, label: 'profile', route: '/profile')
];
