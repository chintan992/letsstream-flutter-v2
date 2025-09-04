import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/terms_acceptance_service.dart';

class TermsAcceptanceDialog extends StatefulWidget {
  final VoidCallback? onAccepted;

  const TermsAcceptanceDialog({super.key, this.onAccepted});

  @override
  State<TermsAcceptanceDialog> createState() => _TermsAcceptanceDialogState();
}

class _TermsAcceptanceDialogState extends State<TermsAcceptanceDialog> {
  bool _termsAccepted = false;
  bool _dmcaAccepted = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button from closing dialog
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.policy,
                      size: 48,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Welcome to Let\'s Stream',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please review and accept our Terms of Service and DMCA Notice to continue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withAlpha(204),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Terms of Service Section
                      _buildSection(
                        'Terms of Service',
                        Icons.gavel,
                        _buildTermsContent(),
                      ),
                      const SizedBox(height: 16),

                      // Terms Checkbox
                      CheckboxListTile(
                        title: const Text('I accept the Terms of Service'),
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      const Divider(),

                      // DMCA Notice Section
                      _buildSection(
                        'DMCA Notice',
                        Icons.warning_amber,
                        _buildDmcaContent(),
                      ),
                      const SizedBox(height: 16),

                      // DMCA Checkbox
                      CheckboxListTile(
                        title: const Text('I accept the DMCA Notice'),
                        value: _dmcaAccepted,
                        onChanged: (value) {
                          setState(() {
                            _dmcaAccepted = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      const SizedBox(height: 20),

                      // Important Notice
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'You must accept both policies to continue using the app.',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _declineAndExit,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Decline & Exit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _termsAccepted && _dmcaAccepted
                            ? _acceptAndContinue
                            : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Accept & Continue'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [Padding(padding: const EdgeInsets.all(16), child: content)],
      ),
    );
  }

  Widget _buildTermsContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Educational Demonstration Notice',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          'This application is strictly an educational demonstration project. We do not host, store, or distribute any media content. All content is fetched from third-party APIs for demonstration purposes only.',
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 12),
        Text(
          'By accepting these terms, you acknowledge that:',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        SizedBox(height: 8),
        Text(
          '• This is an educational demonstration only\n'
          '• No media content is hosted by this app\n'
          '• All content comes from third-party APIs\n'
          '• The service may be discontinued at any time',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDmcaContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Important Notice',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          'This is an educational demonstration project that does not host any content. All content is fetched from third-party APIs. DMCA notices should be directed to the respective content owners or hosting services.',
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 12),
        Text(
          'For copyright concerns:',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
        SizedBox(height: 8),
        Text(
          '• Contact the actual content owner or hosting service\n'
          '• Submit DMCA notices to the appropriate provider\n'
          '• This app serves as an educational interface only',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

    void _acceptAndContinue() async {
    await TermsAcceptanceService.instance.acceptAll();
    if (mounted) {
      widget.onAccepted?.call();
    }
  }

  void _declineAndExit() async {
    await TermsAcceptanceService.instance.declineTerms();
    if (mounted) {
      // Close the app
      SystemNavigator.pop();
    }
  }
}
