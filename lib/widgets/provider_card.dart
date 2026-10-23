import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/provider.dart';

class ProviderCard extends StatelessWidget {
  final ServiceProvider provider;
  final VoidCallback onTap;
  const ProviderCard({super.key, required this.provider, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(width: 82, height: 82, child: provider.imageUrl != null && provider.imageUrl!.isNotEmpty
              ? Image.network(provider.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder())
              : _placeholder()),
          ),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(provider.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            if ((provider.profession ?? provider.categoryName ?? '').isNotEmpty)
              Padding(padding: const EdgeInsets.only(top: 3), child: Text(provider.profession ?? provider.categoryName!, style: const TextStyle(color: AppTheme.gold))),
            if ((provider.address ?? '').isNotEmpty)
              Padding(padding: const EdgeInsets.only(top: 5), child: Text(provider.address!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFFB0BCD0), fontSize: 12))),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.star_rounded, color: AppTheme.gold, size: 17),
              const SizedBox(width: 4),
              Text(provider.rating?.toStringAsFixed(1) ?? '—', style: const TextStyle(fontWeight: FontWeight.w700)),
              Text('  (${provider.reviewCount ?? 0} avis)', style: const TextStyle(color: Color(0xFFAFBCD0), fontSize: 11)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.orange),
            ]),
          ])),
        ]),
      ),
    ),
  );

  Widget _placeholder() => Container(
    color: AppTheme.navy,
    alignment: Alignment.center,
    child: const Icon(Icons.person_outline_rounded, color: AppTheme.gold, size: 35),
  );
}
