import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/offline_service.dart';
import '../../core/models/hive_adapters.dart';

/// Initialize all required services for the application
Future<void> initializeServices() async {
  try {
    // Initialize Hive
    await Hive.initFlutter();

    // Register Hive adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MovieAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TvShowAdapter());
    }

    // Initialize services
    await CacheService.instance.initialize();
    await OfflineService().initialize();

    debugPrint('All services initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize services: $e');
    // Continue with app startup even if services fail to initialize
  }
}
