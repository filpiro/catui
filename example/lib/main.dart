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
            child: CatSegmented<String>(
              segments: {for (final name in _flavors.keys) name: name},
              selected: flavor,
              onChanged: onFlavor,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          const _Section('Actions (enabled, then disabled)'),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            children: [
              EditIconButton(onPressed: () {}),
              DeleteIconButton(onPressed: () {}),
              DangerButton(onPressed: () {}, child: const Text('Elimina')),
              const SizedBox(width: 24),
              const EditIconButton(),
              const DeleteIconButton(),
              const DangerButton(child: Text('Elimina')),
            ],
          ),
          const _Section('Buttons (AppTokens.radius)'),
          Wrap(
            spacing: 12,
            children: [
              FilledButton(onPressed: () {}, child: const Text('Filled')),
              ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
              TextButton(onPressed: () {}, child: const Text('Text')),
            ],
          ),
          const _Section('Select'),
          const Align(alignment: Alignment.centerLeft, child: _SelectDemo()),
          const _Section('Dialog (AppTokens.radius)'),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Elimina elemento'),
                  content: const Text('L\'operazione non è reversibile.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Annulla'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Conferma'),
                    ),
                  ],
                ),
              ),
              child: const Text('Apri dialog'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectDemo extends StatefulWidget {
  const _SelectDemo();

  @override
  State<_SelectDemo> createState() => _SelectDemoState();
}

class _SelectDemoState extends State<_SelectDemo> {
  String _value = 'mocha';

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: _value,
      label: const Text('Flavor'),
      onSelected: (v) => setState(() => _value = v!),
      dropdownMenuEntries: [
        for (final name in _flavors.keys)
          DropdownMenuEntry(value: name, label: name),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
