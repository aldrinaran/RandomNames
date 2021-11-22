import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

Future<void> analyticsSetCurrentScreen(
    String _screenName, String _screenClassOverride) async {
  await analytics.setCurrentScreen(
      screenName: _screenName, screenClassOverride: _screenClassOverride);
}

Future<void> analyticsSendEvent(
    String _eventName, Map<String, dynamic> _parameters) async {
  await analytics.logEvent(name: _eventName, parameters: _parameters);
}
