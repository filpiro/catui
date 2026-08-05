import 'package:catui/catui.dart';
import 'package:flutter/material.dart';

void main() => runApp(const GalleryApp());

/// Every flavor paired with the brightness it was drawn for: latte is the only
/// light one, so the switcher can't produce a washed-out theme by accident.
final _flavors = <String, (Flavor, Brightness)>{
  'latte': (catppuccin.latte, Brightness.light),
  'frappe': (catppuccin.frappe, Brightness.dark),
  'macchiato': (catppuccin.macchiato, Brightness.dark),
  'mocha': (catppuccin.mocha, Brightness.dark),
};

class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  String _flavor = 'mocha';

  @override
  Widget build(BuildContext context) {
    final (flavor, brightness) = _flavors[_flavor]!;
    return MaterialApp(
      title: 'catui gallery',
      debugShowCheckedModeBanner: false,
      theme: catTheme(flavor, brightness),
      home: _Gallery(
        flavor: _flavor,
        onFlavor: (f) => setState(() => _flavor = f),
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  final String flavor;
  final ValueChanged<String> onFlavor;

  const _Gallery({required this.flavor, required this.onFlavor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('catui'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SegmentedButton<String>(
              segments: [
                for (final name in _flavors.keys)
                  ButtonSegment(value: name, label: Text(name)),
              ],
              selected: {flavor},
              onSelectionChanged: (s) => onFlavor(s.first),
              showSelectedIcon: false,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const _Section('Actions (disabled state)'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EditIconButton(),
              const DeleteIconButton(),
              const SizedBox(width: 16),
              DangerButton(onPressed: () {}, child: const Text('Elimina')),
            ],
          ),
          const _Section('Buttons (AppTokens.radius)'),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: [
              FilledButton(onPressed: () {}, child: const Text('Filled')),
              ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
              TextButton(onPressed: () {}, child: const Text('Text')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
