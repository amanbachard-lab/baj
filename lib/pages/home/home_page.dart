import 'package:flutter/material.dart';

import '../../core/api_client.dart';

import '../../models/provider.dart';

import '../../models/service_category.dart';

import '../../services/discovery_service.dart';

import '../../widgets/provider_card.dart';

import '../search/search_page.dart';

import '../profile/profile_page.dart';

import '../requests/requests_page.dart';

import '../favorites/favorites_page.dart';

import '../provider/provider_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  String _firstName = '';

  final DiscoveryService _discovery = DiscoveryService();

  late Future<List<ServiceCategory>> _categoriesFuture;

  late Future<List<ServiceProvider>> _providersFuture;

  @override
  void initState() {
    super.initState();

    _categoriesFuture = _discovery.categories();

    _providersFuture = _discovery.providers();

    _loadAccount();
  }

  Future<void> _loadAccount() async {
    try {
      final account = await ApiClient.instance.get('/api/account');

      if (!mounted || account is! Map) return;

      final firstName = account['firstName']?.toString().trim() ?? '';

      setState(() {
        _firstName = firstName;
      });
    } catch (_) {
      // L'accueil reste accessible si le compte est momentanément indisponible.
    }
  }

  // Icône et couleur associées au nom de chaque service.

  ({IconData icon, Color color}) _categoryStyle(String name) {
    final n = name.toLowerCase();

    if (n.contains('livraison') || n.contains('livreur')) {
      return (
        icon: Icons.delivery_dining_rounded,
        color: const Color(0xFFEF6C00),
      );
    }

    if (n.contains('plomb')) {
      return (
        icon: Icons.plumbing_rounded,
        color: const Color(0xFF008DCE),
      );
    }

    if (n.contains('électric') || n.contains('electric')) {
      return (
        icon: Icons.electrical_services_rounded,
        color: const Color(0xFFE5A000),
      );
    }

    if (n.contains('mécan') || n.contains('mecan')) {
      return (
        icon: Icons.car_repair_rounded,
        color: const Color(0xFF5267D8),
      );
    }

    if (n.contains('coiff')) {
      return (
        icon: Icons.content_cut_rounded,
        color: const Color(0xFFD94F91),
      );
    }

    if (n.contains('restaurant') || n.contains('repas')) {
      return (
        icon: Icons.restaurant_rounded,
        color: const Color(0xFFE74C3C),
      );
    }

    if (n.contains('médec') ||
        n.contains('medec') ||
        n.contains('docteur') ||
        n.contains('spécialiste')) {
      return (
        icon: Icons.medical_services_rounded,
        color: const Color(0xFF16A085),
      );
    }

    if (n.contains('pharmacie')) {
      return (
        icon: Icons.local_pharmacy_rounded,
        color: const Color(0xFF26A65B),
      );
    }

    if (n.contains('chauffeur') || n.contains('transport')) {
      return (
        icon: Icons.local_taxi_rounded,
        color: const Color(0xFF7B61C9),
      );
    }

    if (n.contains('enseign') ||
        n.contains('cours') ||
        n.contains('professeur')) {
      return (
        icon: Icons.school_rounded,
        color: const Color(0xFF2878D0),
      );
    }

    if (n.contains('lavage') || n.contains('nettoyage')) {
      return (
        icon: Icons.local_car_wash_rounded,
        color: const Color(0xFF00A6A6),
      );
    }

    if (n.contains('éleveur') ||
        n.contains('eleveur') ||
        n.contains('élevage') ||
        n.contains('bétail')) {
      return (
        icon: Icons.agriculture_rounded,
        color: const Color(0xFF669C35),
      );
    }

    if (n.contains('téléphone') ||
        n.contains('telephone') ||
        n.contains('mobile')) {
      return (
        icon: Icons.phone_android_rounded,
        color: const Color(0xFF7652C8),
      );
    }

    if (n.contains('réparateur') ||
        n.contains('reparateur') ||
        n.contains('réparation') ||
        n.contains('reparation')) {
      return (
        icon: Icons.build_circle_rounded,
        color: const Color(0xFFDF7732),
      );
    }

    if (n.contains('couture') || n.contains('tailleur')) {
      return (
        icon: Icons.checkroom_rounded,
        color: const Color(0xFFB04ACB),
      );
    }

    if (n.contains('ménage') ||
        n.contains('menage') ||
        n.contains('domestique')) {
      return (
        icon: Icons.cleaning_services_rounded,
        color: const Color(0xFF398D80),
      );
    }

    if (n.contains('construction') ||
        n.contains('maçon') ||
        n.contains('macon')) {
      return (
        icon: Icons.construction_rounded,
        color: const Color(0xFFCB7628),
      );
    }

    if (n.contains('jardin')) {
      return (
        icon: Icons.yard_rounded,
        color: const Color(0xFF4A9C50),
      );
    }

    return (
      icon: Icons.miscellaneous_services_rounded,
      color: const Color(0xFF1769E0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _homeContent(),
      const SearchPage(),
      const RequestsPage(),
      const FavoritesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _tab == 0 ? _buildAppBar() : null,
      body: SafeArea(
        top: _tab != 0,
        child: IndexedStack(
          index: _tab,
          children: pages,
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // AppBar avec le véritable logo BAJ Technologies.

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 86,
      titleSpacing: 16,
      title: Row(
        children: [
          Image.asset(
            'assets/branding/BAJ_wordmark_transparent.png',
            width: 92,
            height: 54,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF10264B),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _firstName.isEmpty ? 'Bonjour 👋' : 'Bonjour, $_firstName 👋',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF10264B),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Quel service recherchez-vous ?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF7B8798),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => setState(() => _tab = 4),
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5FB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF1769E0),
                size: 25,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFEDF0F5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10264B).withOpacity(0.045),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) {
          setState(() => _tab = index);
        },
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        height: 72,
        indicatorColor: const Color(0xFF1769E0).withOpacity(0.10),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          final selected = states.contains(WidgetState.selected);

          return TextStyle(
            fontSize: 10,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            color: selected ? const Color(0xFF1769E0) : const Color(0xFF8994A5),
          );
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Color(0xFF8994A5)),
            selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF1769E0)),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded, color: Color(0xFF8994A5)),
            selectedIcon:
                Icon(Icons.travel_explore_rounded, color: Color(0xFF1769E0)),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined, color: Color(0xFF8994A5)),
            selectedIcon:
                Icon(Icons.calendar_month_rounded, color: Color(0xFF1769E0)),
            label: 'Demandes',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded, color: Color(0xFF8994A5)),
            selectedIcon:
                Icon(Icons.favorite_rounded, color: Color(0xFF1769E0)),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded, color: Color(0xFF8994A5)),
            selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF1769E0)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _homeContent() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        // Bannière premium BAJ-NEMO.

        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1769E0),
                Color(0xFF10264B),
                Color(0xFF081C41),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFD7AD54).withOpacity(0.65),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10264B).withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Le bon professionnel,\nau bon moment.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Trouvez un expert près de vous, découvrez les profils '
                'et contactez le professionnel qui vous convient.',
                style: TextStyle(
                  color: Color(0xFFE0E8F5),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _tab = 1),
                  icon: const Icon(Icons.search_rounded),
                  label: const Text(
                    'Trouver un service',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Explorer les services',
                style: TextStyle(
                  color: Color(0xFF10264B),
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _tab = 1),
              child: const Text(
                'Tout voir',
                style: TextStyle(
                  color: Color(0xFF1769E0),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 3),

        const Text(
          'Choisissez le service qui vous convient.',
          style: TextStyle(
            color: Color(0xFF8994A5),
            fontSize: 12,
          ),
        ),

        // Trois colonnes : icônes colorées sans cartes ni cadres.

        FutureBuilder<List<ServiceCategory>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1769E0),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return _message(
                'Impossible de charger les services.',
                onRetry: () {
                  setState(() {
                    _categoriesFuture = _discovery.categories();
                  });
                },
              );
            }

            final categories = snapshot.data ?? [];

            if (categories.isEmpty) {
              return _message(
                'Aucun service disponible pour le moment.',
                onRetry: () {
                  setState(() {
                    _categoriesFuture = _discovery.categories();
                  });
                },
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 2, bottom: 0),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0,
                crossAxisSpacing: 8,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];

                final style = _categoryStyle(category.name);

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchPage(
                          initialCategoryId: category.id,
                          title: category.name,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          style.icon,
                          size: 30,
                          color: style.color,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),

        const SizedBox(height: 25),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Prestataires disponibles',
                style: TextStyle(
                  color: Color(0xFF10264B),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            const Icon(
              Icons.verified_rounded,
              color: Color(0xFF1769E0),
              size: 21,
            ),
          ],
        ),

        const SizedBox(height: 5),

        const Text(
          'Découvrez les professionnels référencés.',
          style: TextStyle(
            color: Color(0xFF8994A5),
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 14),

        FutureBuilder<List<ServiceProvider>>(
          future: _providersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1769E0),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return _message(
                'Impossible de charger les prestataires.',
                onRetry: () {
                  setState(() {
                    _providersFuture = _discovery.providers();
                  });
                },
              );
            }

            final providers = snapshot.data ?? [];

            if (providers.isEmpty) {
              return _message(
                'Aucun prestataire disponible pour le moment.',
                onRetry: () {
                  setState(() {
                    _providersFuture = _discovery.providers();
                  });
                },
              );
            }

            return Column(
              children: providers.take(6).map((provider) {
                return ProviderCard(
                  provider: provider,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProviderDetailPage(
                          providerId: provider.id,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          },
        ),

        const SizedBox(height: 28),

        // Pied de page de marque.

        Center(
          child: Column(
            children: [
              Container(
                width: 38,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF1769E0).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 3),
              Image.asset(
                'assets/branding/BAJ_wordmark_transparent.png',
                width: 105,
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'BAJ-NEMO',
                    style: TextStyle(
                      color: Color(0xFF10264B),
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              const Text(
                'Les services à portée de main.',
                style: TextStyle(
                  color: Color(0xFF8994A5),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Une solution BAJ Technologies',
                style: TextStyle(
                  color: Color(0xFFB0B8C5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _message(String message, {VoidCallback? onRetry}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF7C8BA1),
            size: 26,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF53647A),
              fontSize: 13,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
            ),
          ],
        ],
      ),
    );
  }
}
