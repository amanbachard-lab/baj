import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  final String? content;
  final String? version;

  const TermsPage({
    super.key,
    this.content,
    this.version,
  });

  @override
  Widget build(BuildContext context) {
    final terms = content?.trim() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Conditions générales',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172B4D),
        elevation: 0,
      ),
      body: terms.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Les conditions générales ne sont pas encore disponibles.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF667085),
                  ),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(22),
              children: [
                const Text(
                  'BAJ-NEMO — Conditions générales',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF172B4D),
                  ),
                ),
                if (version != null && version!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Version $version',
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SelectableText(
                  terms,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: Color(0xFF27364B),
                  ),
                ),
              ],
            ),
    );
  }
}
