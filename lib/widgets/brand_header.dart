import 'package:flutter/material.dart';
import '../core/app_config.dart';
import '../core/app_theme.dart';

class BrandHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const BrandHeader({super.key, required this.title, this.subtitle});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.orange, AppTheme.gold]),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: const Text('BAJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
    ),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
      Text(subtitle ?? AppConfig.tagline, style: const TextStyle(color: Color(0xFFAFBCD0), fontSize: 12)),
    ])),
  ]);
}
