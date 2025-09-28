import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/core/app/app_config.dart';
import 'src/core/app/app_providers.dart';

/// Main entry point for the Let's Stream application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (gracefully handle missing .env file)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env file might not exist in production builds
    // Environment variables should be injected during build process
    debugPrint('Warning: Could not load .env file: $e');
  }

  // Initialize all required services
  await initializeServices();

  // Start the application
  runApp(const ProviderScope(child: AppProviderScope()));
}
