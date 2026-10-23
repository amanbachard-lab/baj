import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/api_endpoints.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  static const Color bordeaux = Color(0xFF8B1538);
  static const Color bleuFonce = Color(0xFF17365D);
  static const Color fond = Color(0xFFF6F7FB);

  late Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiClient.instance.get(ApiEndpoints.favorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fond,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: bleuFonce,
        title: const Text(
          'Mes favoris',
          style: TextStyle(
            color: bleuFonce,
            fontWeight: FontWeight.w800,
            fontSize: 21,
          ),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<dynamic>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: bordeaux),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 52,
                      color: bordeaux,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Favoris indisponibles',
                      style: TextStyle(
                        color: bleuFonce,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _future = ApiClient.instance.get(
                            ApiEndpoints.favorites,
                          );
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Réessayer'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: bordeaux,
                        side: const BorderSide(color: bordeaux),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data;
          final List raw = data is List
              ? data
              : data is Map && data['content'] is List
                  ? data['content'] as List
                  : [];

          if (raw.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: bordeaux.withValues(alpha: 0.07),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 54,
                        color: bordeaux,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Aucun favori pour le moment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: bleuFonce,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Vos prestataires favoris apparaîtront ici.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            itemCount: raw.length,
            itemBuilder: (context, index) {
              final item = raw[index];
              final Map p = item is Map && item['provider'] is Map
                  ? item['provider'] as Map
                  : item is Map
                      ? item
                      : {};

              final name = (p['name'] ?? 'Prestataire').toString();
              final profession = (p['profession'] ?? '').toString();

              return Container(
                margin: const EdgeInsets.only(bottom: 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE9EAF0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: bleuFonce.withValues(alpha: 0.055),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: bordeaux.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: bordeaux,
                      size: 27,
                    ),
                  ),
                  title: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: bleuFonce,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: profession.isEmpty
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            profession,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: bleuFonce,
                    size: 16,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
