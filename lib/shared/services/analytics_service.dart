import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsService {
  final SupabaseClient supabase;

  AnalyticsService({required this.supabase});

  Future<void> logEvent({required String eventName, Map<String, dynamic>? parameters}) async {
    try {
      if (kDebugMode) {
        print('Analytics event: $eventName, parameters: $parameters');
      }
      await supabase.from('analytics').insert({
        'event_name': eventName,
        'parameters': parameters,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error on sending analytics event: $e');
    }
  }
}
