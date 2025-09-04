import 'package:shared_preferences/shared_preferences.dart';

class TermsAcceptanceService {
  static const String _termsAcceptedKey = 'terms_accepted';
  static const String _dmcaAcceptedKey = 'dmca_accepted';
  static const String _firstLaunchKey = 'first_launch';

  static TermsAcceptanceService? _instance;
  static TermsAcceptanceService get instance =>
      _instance ??= TermsAcceptanceService._();

  TermsAcceptanceService._();

  /// Check if this is the first launch of the app
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  /// Check if user has accepted terms
  Future<bool> hasAcceptedTerms() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_termsAcceptedKey) ?? false;
  }

  /// Check if user has accepted DMCA policy
  Future<bool> hasAcceptedDmca() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_dmcaAcceptedKey) ?? false;
  }

  /// Check if user has accepted both terms and DMCA
  Future<bool> hasAcceptedAll() async {
    final termsAccepted = await hasAcceptedTerms();
    final dmcaAccepted = await hasAcceptedDmca();
    return termsAccepted && dmcaAccepted;
  }

  /// Accept terms of service
  Future<void> acceptTerms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_termsAcceptedKey, true);
  }

  /// Accept DMCA policy
  Future<void> acceptDmca() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dmcaAcceptedKey, true);
  }

  /// Accept both terms and DMCA
  Future<void> acceptAll() async {
    await acceptTerms();
    await acceptDmca();
    await _markFirstLaunchComplete();
  }

  /// Decline terms (reset acceptance)
  Future<void> declineTerms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_termsAcceptedKey, false);
    await prefs.setBool(_dmcaAcceptedKey, false);
  }

  /// Mark first launch as complete
  Future<void> _markFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  /// Reset all acceptance states (for testing)
  Future<void> resetAcceptance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_termsAcceptedKey);
    await prefs.remove(_dmcaAcceptedKey);
    await prefs.remove(_firstLaunchKey);
  }
}
