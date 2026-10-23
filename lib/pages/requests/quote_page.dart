import 'package:flutter/material.dart';

import '../../models/provider.dart';
import '../../services/transaction_service.dart';

class QuotePage extends StatefulWidget {
  final ServiceProvider provider;

  const QuotePage({super.key, required this.provider});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  static const Color bordeaux = Color(0xFF8B1538);
  static const Color bleuFonce = Color(0xFF17365D);
  static const Color fond = Color(0xFFF6F7FB);

  final TextEditingController _description = TextEditingController();

  bool _busy = false;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final description = _description.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Décrivez votre besoin avant de continuer.'),
        ),
      );
      return;
    }

    setState(() => _busy = true);

    try {
      await TransactionService().requestQuote(
        providerId: widget.provider.id,
        description: description,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demande de devis envoyée.'),
          backgroundColor: bleuFonce,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Envoi impossible : $e'),
          backgroundColor: bordeaux,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: bleuFonce,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Demander un devis',
          style: TextStyle(
            color: bleuFonce,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        children: [
          // En-tête
          const Text(
            'Votre projet, notre expertise',
            style: TextStyle(
              color: bleuFonce,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Décrivez votre besoin pour permettre au prestataire '
            'de préparer une proposition adaptée.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          // Carte du prestataire
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: bleuFonce,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: bleuFonce.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.business_center_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Prestataire sélectionné',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.provider.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (widget.provider.profession != null &&
                          widget.provider.profession!.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          widget.provider.profession!,
                          style: const TextStyle(
                            color: Color(0xFFE5C4CF),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // Formulaire
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE7EAF0),
              ),
              boxShadow: [
                BoxShadow(
                  color: bleuFonce.withValues(alpha: 0.045),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      color: bordeaux,
                      size: 25,
                    ),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'Détails de votre demande',
                        style: TextStyle(
                          color: bleuFonce,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                const Text(
                  'Précisez le service souhaité, le lieu et les '
                  'informations utiles à votre projet.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _description,
                  maxLines: 7,
                  minLines: 5,
                  maxLength: 2000,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Ex. : décrivez le service recherché, '
                        'les dimensions, le lieu d’intervention '
                        'ou vos besoins particuliers...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9AA3B2),
                      fontSize: 13,
                      height: 1.6,
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: fond,
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFFE2E6EF),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFFE2E6EF),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: bordeaux,
                        width: 1.5,
                      ),
                    ),
                    counterStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: bordeaux,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Une description précise aidera le prestataire '
                        'à mieux comprendre votre demande.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Envoi
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _busy ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: bordeaux,
                foregroundColor: Colors.white,
                disabledBackgroundColor: bordeaux.withValues(alpha: 0.5),
                elevation: 3,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _busy
                  ? const SizedBox(
                      width: 23,
                      height: 23,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Envoyer ma demande de devis',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Votre demande sera transmise au prestataire sélectionné.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8994A7),
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
