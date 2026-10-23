import 'package:flutter/material.dart';

class AsyncState<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T data) builder;
  const AsyncState({super.key, required this.future, required this.builder});
  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_rounded, size: 42, color: Colors.orangeAccent),
            const SizedBox(height: 12),
            Text('Impossible de charger les données.\n${snapshot.error}', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SizedBox.shrink())), child: const Text('Fermer')),
          ]),
        ));
      }
      return builder(snapshot.data as T);
    },
  );
}
