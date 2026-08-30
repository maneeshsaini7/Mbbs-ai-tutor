import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central place to read configuration/secrets.
///
/// Nothing here is hardcoded. Values come from a local, gitignored `.env`
/// file in debug (see `.env.example`) or from `--dart-define` values injected
/// by your CI in release builds. Screens and services should read from here,
/// never from `dotenv` directly, so the source can change without touching
/// call sites.
class Env {
  Env._();

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // .env is optional for Phase 1 — mock repositories don't need it.
      // In later phases, missing required values should fail fast instead
      // of silently falling back, so real backends are never mistaken for
      // the mock ones.
    }
  }

  static String get backendBaseUrl =>
      _read('BACKEND_BASE_URL', fallback: '');

  static String get firebaseApiKey => _read('FIREBASE_API_KEY');
  static String get firebaseAppId => _read('FIREBASE_APP_ID');
  static String get firebaseProjectId => _read('FIREBASE_PROJECT_ID');
  static String get firebaseMessagingSenderId =>
      _read('FIREBASE_MESSAGING_SENDER_ID');

  static String _read(String key, {String fallback = ''}) {
    const fromDefine = String.fromEnvironment('');
    // Prefer --dart-define (release), fall back to .env (debug), then to
    // an explicit empty default rather than throwing, so Phase 1's mock
    // repositories keep working with no configuration at all.
    return fromDefine.isNotEmpty
        ? fromDefine
        : (dotenv.maybeGet(key) ?? fallback);
  }
}
