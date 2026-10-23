import 'package:flutter/material.dart';
import '../../services/transaction_service.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage>
    with SingleTickerProviderStateMixin {
  static const Color bordeaux = Color(0xFF8B1538);
  static const Color bleuFonce = Color(0xFF17365D);
  static const Color fond = Color(0xFFF6F7FB);

  late TabController _tabs;
  final _service = TransactionService();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: fond,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: bleuFonce,
          elevation: 0,
          title: const Text(
            'Mes demandes',
            style: TextStyle(
              color: bleuFonce,
              fontWeight: FontWeight.w800,
            ),
          ),
          bottom: TabBar(
            controller: _tabs,
            indicatorColor: bordeaux,
            indicatorWeight: 3,
            labelColor: bordeaux,
            unselectedLabelColor: bleuFonce,
            tabs: const [
              Tab(text: 'Rendez-vous'),
              Tab(text: 'Devis'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabs,
          children: [
            _list(
              _service.myAppointments(),
              'Aucun rendez-vous pour le moment.',
            ),
            _list(
              _service.myQuotes(),
              'Aucune demande de devis pour le moment.',
            ),
          ],
        ),
      );

  Widget _list(Future<dynamic> future, String empty) => FutureBuilder<dynamic>(
        future: future,
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: bordeaux),
            );
          }

          if (s.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Chargement impossible : ${s.error}',
                  style: const TextStyle(color: bleuFonce),
                ),
              ),
            );
          }

          final raw = s.data is List
              ? s.data as List
              : (s.data is Map && s.data['content'] is List
                  ? s.data['content'] as List
                  : []);

          if (raw.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  empty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: bleuFonce,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: raw.length,
            itemBuilder: (_, i) {
              final item = raw[i] as Map;

              return Card(
                color: Colors.white,
                elevation: 2,
                shadowColor: bleuFonce.withValues(alpha: 0.08),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: Color(0xFFE7EAF0),
                  ),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.assignment_outlined,
                    color: bordeaux,
                  ),
                  title: Text(
                    (item['providerName'] ??
                            item['provider']?['name'] ??
                            item['description'] ??
                            'Demande')
                        .toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: bleuFonce,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    (item['status'] ??
                            item['dateTime'] ??
                            item['createdDate'] ??
                            '')
                        .toString(),
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
}
