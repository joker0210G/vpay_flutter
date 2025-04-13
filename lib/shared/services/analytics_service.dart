import 'package:flutter/foundation.dart';

class AnalyticsService {
  void logEvent({required String eventName, Map<String, dynamic>? parameters}) {
    try {
      if (kDebugMode) {
        print('Analytics event: $eventName, parameters: $parameters');
      }
      //TODO: send to analytics services like firebase or others.
    } catch (e) {
      print('Error on sending analytics event: $e');
    }
  }
}
