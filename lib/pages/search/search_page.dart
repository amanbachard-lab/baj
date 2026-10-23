import 'package:flutter/material.dart';
import '../../models/provider.dart';
import '../../services/discovery_service.dart';
import '../../widgets/provider_card.dart';
import '../provider/provider_detail_page.dart';

class SearchPage extends StatefulWidget {
  final String? initialCategoryId;
  final String? title;

  const SearchPage({
    super.key,
    this.initialCategoryId,
    this.title,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const Color bordeaux = Color(0xFF8B1538);
  static const Color bleuFonce = Color(0xFF17365D);
  static const Color fond = Color(0xFFF6F7FB);

  final _query = TextEditingController();
  final _discovery = DiscoveryService();

  List<ServiceProvider> _results = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      _results = await _discovery.providers(
        query: _query.text,
        categoryId: widget.initialCategoryId,
      );
    } catch (e) {
      _error = e.toString();
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: fond,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: bleuFonce,
          surfaceTintColor: Colors.white,
          elevation: 0,
          title: Text(
            widget.title ?? 'Explorer les services',
            style: const TextStyle(
              color: bleuFonce,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _query,
                      onSubmitted: (_) => _search(),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: bordeaux,
                        ),
                        hintText: 'Métier, service, nom…',
                        filled: true,
                        fillColor: Colors.white,
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
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _search,
                    style: IconButton.styleFrom(
                      backgroundColor: bordeaux,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: bordeaux,
                      ),
                    )
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Recherche impossible : $_error',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: bleuFonce,
                              ),
                            ),
                          ),
                        )
                      : _results.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun résultat. Essayez un autre terme.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: bleuFonce,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: _results.length,
                              itemBuilder: (_, i) => ProviderCard(
                                provider: _results[i],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProviderDetailPage(
                                      providerId: _results[i].id,
                                    ),
                                  ),
                                ),
                              ),
                            ),
            ),
          ],
        ),
      );
}
