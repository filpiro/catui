import 'package:flutter/material.dart';

/// Yes/no dialog. [danger] paints the confirm button with `error` for the
/// flows that destroy data; everything else gets the filled button.
///
/// Labels are the caller's: catui states no language.
Future<bool> catConfirm(
  BuildContext context, {
  required String title,
  String? message,
  required String confirm,
  required String cancel,
  bool danger = false,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancel),
          ),
          FilledButton(
            style: danger
                ? FilledButton.styleFrom(
                    backgroundColor: scheme.error,
                    foregroundColor: scheme.onError,
                  )
                : null,
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirm),
          ),
        ],
      );
    },
  );
  return ok == true;
}

/// One-field dialog: focus starts in the field, Enter confirms, and a blank
/// name cannot be confirmed. Returns the trimmed text, or null if cancelled.
Future<String?> catTextInput(
  BuildContext context, {
  required String title,
  required String label,
  required String confirm,
  required String cancel,
  String initial = '',
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _TextInputDialog(
      title: title,
      label: label,
      confirm: confirm,
      cancel: cancel,
      initial: initial,
    ),
  );
}

class _TextInputDialog extends StatefulWidget {
  const _TextInputDialog({
    required this.title,
    required this.label,
    required this.confirm,
    required this.cancel,
    required this.initial,
  });

  final String title;
  final String label;
  final String confirm;
  final String cancel;
  final String initial;

  @override
  State<_TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<_TextInputDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    Navigator.pop(context, text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(labelText: widget.label),
        onSubmitted: (_) => _submit(),
        // Re-runs the builder so the confirm button follows the field.
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.cancel),
        ),
        FilledButton(
          onPressed: _controller.text.trim().isEmpty ? null : _submit,
          child: Text(widget.confirm),
        ),
      ],
    );
  }
}

/// The one way to show a message. A new one replaces whatever is on screen:
/// stale feedback queued behind a fresh action is worse than no feedback.
///
/// Takes the messenger, not a context, because most callers capture it before
/// an await.
void catSnack(ScaffoldMessengerState messenger, String message) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
