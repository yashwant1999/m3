import 'package:flutter/material.dart';

class CustomNavigation {
  static push(BuildContext context, {required Widget page}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
