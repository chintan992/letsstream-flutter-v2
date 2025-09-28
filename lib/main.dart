import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/core/app/app_config.dart';
import 'src/core/app/app_providers.dart';

/// Main entry point for the Let's Stream application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize all required services
  await initializeServices();

  // Start the application
  runApp(const ProviderScope(child: AppProviderScope()));
}
