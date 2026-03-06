import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/helpers/format_helpers.dart';

class CustomFieldListItem extends StatelessWidget {
  final CustomField field;
  final VoidCallback? onEdit;

  const CustomFieldListItem({super.key, required this.field, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(field.name),
      subtitle: Text(_dataTypeDisplayName(field.dataType)),
      leading: CircleAvatar(child: Icon(_dataTypeIcon(field.dataType))),
      trailing: Text(
        formatMaxCount(field.documentCount),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onEdit,
    );
  }

  static String _dataTypeDisplayName(DataTypeEnum dataType) {
    return switch (dataType) {
      DataTypeEnum.string => 'Text',
      DataTypeEnum.url => 'URL',
      DataTypeEnum.date => 'Date',
      DataTypeEnum.boolean => 'Boolean',
      DataTypeEnum.integer => 'Integer',
      DataTypeEnum.float => 'Float',
      DataTypeEnum.monetary => 'Monetary',
      DataTypeEnum.documentlink => 'Document Link',
      DataTypeEnum.select => 'Select',
    };
  }

  static IconData _dataTypeIcon(DataTypeEnum dataType) {
    return switch (dataType) {
      DataTypeEnum.string => Icons.text_fields,
      DataTypeEnum.url => Icons.link,
      DataTypeEnum.date => Icons.calendar_today,
      DataTypeEnum.boolean => Icons.toggle_on_outlined,
      DataTypeEnum.integer => Icons.numbers,
      DataTypeEnum.float => Icons.percent,
      DataTypeEnum.monetary => Icons.attach_money,
      DataTypeEnum.documentlink => Icons.description_outlined,
      DataTypeEnum.select => Icons.list,
    };
  }
}
