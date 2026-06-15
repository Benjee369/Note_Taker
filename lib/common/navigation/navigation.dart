import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Navigation {
  static Future<dynamic> navigateTo(BuildContext context, Widget child) {
    return Navigator.push(
      context,
      _getRoute(child),
    );
  }

  static Future<dynamic> navigateAndReplace(BuildContext context, Widget child) {
    return Navigator.pushAndRemoveUntil(
      context,
      _getRoute(child),
          (route) => false,
    );
  }

  static PageRoute _getRoute(Widget child) {
    if (kIsWeb) {
      return MaterialPageRoute(builder: (_) => child);
    }

    // iOS style
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (_) => child);
    }

    // Android + Windows + Linux + macOS
    return MaterialPageRoute(builder: (_) => child);
  }
}