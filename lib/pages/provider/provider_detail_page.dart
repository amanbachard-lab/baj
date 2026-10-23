import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/app_theme.dart';
import '../../models/provider.dart';
import '../../services/discovery_service.dart';
import '../requests/quote_page.dart';
import '../requests/appointment_page.dart';

class ProviderDetailPage extends StatefulWidget {
  final String providerId;

  const ProviderDetailPage({super.key, required this.providerId});

  @override
  State<ProviderDetailPage> createState() => _ProviderDetailPageState();
}

class _ProviderDetailPageState extends State<ProviderDetailPage> {
  static const Color bordeaux = Color(0xFF8B1538);
  static const Color bleuFonce = Color(0xFF17365D);
  static const Color fond = Color(0xFFF6F7FB);

  late Future<ServiceProvider> _future;

  @override
  void initState() {
    super.initState();
    _future = DiscoveryService().provider(widget.providerId);
  }

  Future<void> _open(String raw) async {
    final uri = Uri.tryParse(raw);

    if (uri == null || !await canLaunchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Action non disponible sur cet appareil.'),
          ),
        );
      }
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: bleuFonce,
        ),
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    bool primary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: primary
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(title),
              style: ElevatedButton.styleFrom(
                backgroundColor: bordeaux,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(title),
              style: OutlinedButton.styleFrom(
                foregroundColor: bleuFonce,
                side: const BorderSide(color: Color(0xFFD9DFEA)),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
    );
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
          'Profil prestataire',
          style: TextStyle(
            color: bleuFonce,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: FutureBuilder<ServiceProvider>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: bordeaux),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_off_outlined,
                      size: 52,
                      color: bordeaux,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Profil indisponible',
                      style: TextStyle(
                        color: bleuFonce,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error ?? 'Prestataire introuvable.'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _future = DiscoveryService().provider(
                            widget.providerId,
                          );
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Réessayer'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: bordeaux,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final p = snapshot.data!;
          final hasImage = p.imageUrl?.isNotEmpty ?? false;
          final hasPhone = p.phone?.isNotEmpty ?? false;
          final hasWhatsApp = p.whatsapp?.isNotEmpty ?? false;
          final hasCoordinates = p.latitude != null && p.longitude != null;

          final whatsappNumber =
              (p.whatsapp ?? '').replaceAll(RegExp(r'[^0-9]'), '');

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
            children: [
              // Profil principal
              Container(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE9EAF0)),
                  boxShadow: [
                    BoxShadow(
                      color: bleuFonce.withValues(alpha: 0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: bordeaux.withValues(alpha: 0.35),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: bleuFonce,
                        backgroundImage:
                            hasImage ? NetworkImage(p.imageUrl!) : null,
                        child: hasImage
                            ? null
                            : const Icon(
                                Icons.person_rounded,
                                size: 48,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      p.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: bleuFonce,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (p.profession != null && p.profession!.isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: bordeaux.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          p.profession!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: bordeaux,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: fond,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFE0A323),
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            p.rating?.toStringAsFixed(1) ?? '—',
                            style: const TextStyle(
                              color: bleuFonce,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '· ${p.reviewCount ?? 0} avis',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (p.address != null && p.address!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: bordeaux,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              p.address!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Description
              if ((p.description ?? '').isNotEmpty) ...[
                _sectionTitle('À propos'),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE9EAF0)),
                    boxShadow: [
                      BoxShadow(
                        color: bleuFonce.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    p.description!,
                    style: const TextStyle(
                      color: Color(0xFF46546A),
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
              ],

              // Contact
              _sectionTitle('Contacter le prestataire'),
              if (hasPhone)
                _actionCard(
                  icon: Icons.call_rounded,
                  title: 'Appeler',
                  onPressed: () => _open('tel:${p.phone}'),
                ),
              if (hasPhone && hasWhatsApp) const SizedBox(height: 10),
              if (hasWhatsApp)
                _actionCard(
                  icon: Icons.chat_rounded,
                  title: 'Discuter sur WhatsApp',
                  onPressed: () => _open('https://wa.me/$whatsappNumber'),
                ),

              if (hasPhone || hasWhatsApp) const SizedBox(height: 22),

              // Localisation
              if (hasCoordinates) ...[
                _sectionTitle('Localisation'),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    height: 220,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(p.latitude!, p.longitude!),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(p.id),
                          position: LatLng(p.latitude!, p.longitude!),
                          infoWindow: InfoWindow(title: p.name),
                        ),
                      },
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _actionCard(
                  icon: Icons.directions_rounded,
                  title: 'Calculer l’itinéraire',
                  onPressed: () => _open(
                    'https://www.google.com/maps/dir/?api=1'
                    '&destination=${p.latitude},${p.longitude}',
                  ),
                ),
                const SizedBox(height: 22),
              ],

              // Réservation et devis
              _sectionTitle('Services et réservation'),
              _actionCard(
                icon: Icons.request_quote_rounded,
                title: 'Demander un devis',
                primary: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuotePage(provider: p),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _actionCard(
                icon: Icons.calendar_month_rounded,
                title: 'Prendre rendez-vous',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentPage(provider: p),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'Les avis détaillés seront disponibles lorsque '
                  'le service des avis sera connecté.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8994A7),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
