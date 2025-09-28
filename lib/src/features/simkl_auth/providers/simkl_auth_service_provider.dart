import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/simkl/simkl_api_client.dart';
import '../services/simkl_auth_service.dart';

/// SimklApiClient provider
final simklApiClientProvider = Provider<SimklApiClient>((ref) {
  return SimklApiClient();
});

/// SimklAuthService provider
final simklAuthServiceProvider = Provider<SimklAuthService>((ref) {
  final apiClient = ref.watch(simklApiClientProvider);
  // Create a WidgetRef-like interface for the service
  return SimklAuthService(apiClient, ref as dynamic);
});
