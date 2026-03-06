import 'package:flutter/material.dart';

/// A form field for editing a document link custom field value.
///
/// Document links are stored as a list of integer document IDs.
/// This widget provides a chip-based interface to add and remove linked
/// document IDs.
class DocumentLinkFormField extends StatefulWidget {
  final String labelText;
  final Object? value;
  final bool enabled;
  final ValueChanged<Object?> onChanged;
  final String? errorText;

  const DocumentLinkFormField({
    super.key,
    required this.labelText,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<DocumentLinkFormField> createState() => _DocumentLinkFormFieldState();
}

class _DocumentLinkFormFieldState extends State<DocumentLinkFormField> {
  late final TextEditingController _controller;

  List<int> _parseIds() {
    if (widget.value is List) {
      return (widget.value as List).whereType<int>().toList();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addId(String text) {
    final id = int.tryParse(text.trim());
    if (id == null) return;

    final currentIds = _parseIds();
    if (!currentIds.contains(id)) {
      final newIds = [...currentIds, id];
      widget.onChanged(newIds);
    }
    _controller.clear();
  }

  void _removeId(int id) {
    final currentIds = _parseIds();
    final newIds = currentIds.where((i) => i != id).toList();
    widget.onChanged(newIds.isEmpty ? null : newIds);
  }

  @override
  Widget build(BuildContext context) {
    final ids = _parseIds();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (ids.isNotEmpty)
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: ids.map((id) {
              return Chip(
                label: Text('Doc #$id'),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: widget.enabled ? () => _removeId(id) : null,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        const SizedBox(height: 8),
        if (widget.enabled)
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: widget.labelText,
              errorText: widget.errorText,
              border: const OutlineInputBorder(),
              isDense: true,
              hintText: 'Enter document ID',
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addId(_controller.text),
              ),
            ),
            onSubmitted: _addId,
          ),
      ],
    );
  }
}
