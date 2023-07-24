import 'dart:io';

import 'package:flutter_displaymode/flutter_displaymode.dart';

class AppLogic {
  /// Initialize the app and all main actors.
  /// Loads settings, sets up services etc.
  Future<void> bootstrap() async {
    // Set preferred refresh rate to the max possible (the OS may ignore this)
    if (Platform.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }
  }
}
