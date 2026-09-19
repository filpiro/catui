import 'package:flutter/material.dart';

import 'tokens.dart';

/// Outlined, read-only field that shows a date and time; tap to pick the date,
/// then the time. Looks like the text fields because it is an [InputDecorator]
/// under the same input theme.
///
/// The app passes [label] and [placeholder] (shown while [value] is null).
/// [onChanged] fires only with a picked value, so an unset field can be set but
/// never cleared. Set [error] to show a message under the field.
class CatDateTimeField extends StatelessWidget {
  final String label;
  final String placeholder;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String? error;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CatDateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.placeholder = '',
    this.error,
    this.firstDate,
    this.lastDate,
  });

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String format(DateTime t) =>
      '${_two(t.day)}/${_two(t.month)}/${t.year} ${_two(t.hour)}:${_two(t.minute)}';

  Future<void> _pick(BuildContext context) async {
    final initial = value ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = value;
    return InkWell(
      borderRadius: BorderRadius.circular(AppTokens.radius),
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: error,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(
          v == null ? placeholder : format(v),
          style: v == null
              ? TextStyle(color: theme.colorScheme.onSurfaceVariant)
              : null,
        ),
      ),
    );
  }
}
