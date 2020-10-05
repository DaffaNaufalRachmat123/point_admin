import 'package:flutter/material.dart';
import 'package:points_admin/Screens/LoginScreen.dart';

void main() {
  runApp(MaterialApp(
    theme : ThemeData(
      visualDensity : VisualDensity.adaptivePlatformDensity
    ),
    home : LoginScreen()
  ));
}
