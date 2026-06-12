import 'package:flutter/foundation.dart';

bool get isMobile {
  if (kIsWeb) return false;

  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}