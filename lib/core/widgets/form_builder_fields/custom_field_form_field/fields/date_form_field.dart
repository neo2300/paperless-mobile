import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A form field for editing a date custom field value.
///
/// The value is stored as an ISO 8601 date string (yyyy-MM-dd).
class DateFormField extends StatelessWidget {
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;
  final String? errorText;
  final String labelText;

  const DateFormField({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.errorText,
    required this.labelText,
  });

  DateTime? _parseDate() {
    if (value == null) return null;
    return DateTime.tryParse('$value');
  }

  @override
  Widget build(BuildContext context) {
    final date = _parseDate();
    final locale = Localizations.localeOf(context).toString();
    final displayText = date != null
        ? DateFormat.yMMMMd(locale).format(date)
        : '';

    return InkWell(
      onTap: enabled
          ? () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                // Store as ISO 8601 date string (yyyy-MM-dd).
                onChanged(DateFormat('yyyy-MM-dd').format(picked));
              }
            }
          : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          errorText: errorText,
          isDense: true,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (date != null && enabled)
                IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () => onChanged(null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.calendar_today, size: 20),
              ),
            ],
          ),
        ),
        child: Text(displayText, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
