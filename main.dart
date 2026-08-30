import 'package:flutter/material.dart';

import 'app/app.dart';
import 'config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();

  // Firebase.initializeApp() is added here in Phase 3, once auth is wired.
  // Deliberately not called yet so Phase 1 has zero setup requirements.

  runApp(const MbbsAiTutorApp());
}
