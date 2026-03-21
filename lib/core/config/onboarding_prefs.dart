import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingDone = 'onboarding_completed_v1';

Future<bool> loadOnboardingCompleted() async {
  final p = await SharedPreferences.getInstance();
  return p.getBool(_kOnboardingDone) ?? false;
}

Future<void> setOnboardingCompleted(bool value) async {
  final p = await SharedPreferences.getInstance();
  await p.setBool(_kOnboardingDone, value);
}
