import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../router/app_router.dart';
import '../../shared/theme/theme_providers.dart';
import '../../core/services/terms_acceptance_service.dart';
import '../../shared/widgets/terms_acceptance_dialog.dart';

/// Provider scope widget that manages the app's state and routing
class AppProviderScope extends ConsumerStatefulWidget {
  /// Creates an AppProviderScope widget.
  ///
  /// The [key] parameter is used to identify this widget in the widget tree.
  const AppProviderScope({super.key});

  @override
  ConsumerState<AppProviderScope> createState() => _AppProviderScopeState();
}

class _AppProviderScopeState extends ConsumerState<AppProviderScope> {
  bool _termsAccepted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkTermsAcceptance();
  }

  Future<void> _checkTermsAcceptance() async {
    final accepted = await TermsAcceptanceService.instance.hasAcceptedAll();
    setState(() {
      _termsAccepted = accepted;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(currentThemeProvider);

    if (_isLoading) {
      return MaterialApp(
        title: 'Let\'s Stream',
        debugShowCheckedModeBanner: false,
        theme: currentTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp.router(
      title: 'Let\'s Stream',
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      routerConfig: appRouter,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (!_termsAccepted)
              Container(
                color: Colors.black.withAlpha(128),
                child: TermsAcceptanceDialog(
                  onAccepted: () {
                    setState(() {
                      _termsAccepted = true;
                    });
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
