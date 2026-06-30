
import 'package:flutter/material.dart';


class AppIcon {
  final String name;      
  final IconData icon;   
  final String label;     

  const AppIcon({
    required this.name,
    required this.icon,
    required this.label,
  });
}


const List<AppIcon> kTodoIcons = [
  AppIcon(name: 'home',       icon: Icons.home_rounded,        label: 'Ev'),
  AppIcon(name: 'work',       icon: Icons.work_rounded,        label: 'İş'),
  AppIcon(name: 'shopping',   icon: Icons.shopping_cart_rounded, label: 'Alışveriş'),
  AppIcon(name: 'health',     icon: Icons.favorite_rounded,    label: 'Sağlık'),
  AppIcon(name: 'education',  icon: Icons.school_rounded,      label: 'Eğitim'),
  AppIcon(name: 'sport',      icon: Icons.sports_soccer_rounded, label: 'Spor'),
  AppIcon(name: 'travel',     icon: Icons.flight_rounded,      label: 'Seyahat'),
  AppIcon(name: 'finance',    icon: Icons.account_balance_wallet_rounded, label: 'Finans'),
  AppIcon(name: 'social',     icon: Icons.people_rounded,      label: 'Sosyal'),
  AppIcon(name: 'other',      icon: Icons.star_rounded,        label: 'Diğer'),
];


IconData getIconData(String iconName) {
  final found = kTodoIcons.firstWhere(
    (e) => e.name == iconName,
    orElse: () => kTodoIcons.last, 
  );
  return found.icon;
}


String getIconLabel(String iconName) {
  final found = kTodoIcons.firstWhere(
    (e) => e.name == iconName,
    orElse: () => kTodoIcons.last,
  );
  return found.label;
}