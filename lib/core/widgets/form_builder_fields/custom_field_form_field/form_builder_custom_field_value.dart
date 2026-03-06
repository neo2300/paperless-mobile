import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/custom_field_form_field/fields/boolean_form_field.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/custom_field_form_field/fields/date_form_field.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/custom_field_form_field/fields/document_link_form_field.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/custom_field_form_field/fields/float_form_field.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/custom_field_form_field/fields/integer_form_field.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/custom_field_form_field/fields/monetary_form_field.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/custom_field_form_field/fields/select_form_field.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/custom_field_form_field/fields/string_form_field.dart';
import 'package:paperless_mobile/core/widgets/form_builder_fields/custom_field_form_field/fields/url_form_field.dart';

/// A form builder field that renders the appropriate edit widget for a
/// [CustomFieldInstance] based on the [CustomField.dataType].
///
/// The data type cannot be changed — only the value can be edited.
/// This widget delegates to a type-specific sub-widget for each
/// [DataTypeEnum] value.
class FormBuilderCustomFieldValue extends FormBuilderField<Object?> {
  final CustomField customField;

  FormBuilderCustomFieldValue({
    super.key,
    required super.name,
    required this.customField,
    super.initialValue,
    super.validator,
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    InputDecoration decoration = const InputDecoration(),
  }) : super(
         builder: (FormFieldState<Object?> field) {
           final state = field as FormBuilderCustomFieldValueState;

           return _CustomFieldValueEditor(
             labelText: customField.name,
             errorText: state.errorText,
             dataType: customField.dataType,
             value: state.value,
             extraData: customField.extraData,
             enabled: state.enabled,
             onChanged: (newValue) {
               state.didChange(newValue);
             },
           );
         },
       );

  @override
  FormBuilderCustomFieldValueState createState() =>
      FormBuilderCustomFieldValueState();
}

class FormBuilderCustomFieldValueState
    extends FormBuilderFieldState<FormBuilderCustomFieldValue, Object?> {}

/// Internal widget that switches on [DataTypeEnum] and renders the appropriate
/// edit widget for the custom field value.
class _CustomFieldValueEditor extends StatelessWidget {
  final DataTypeEnum dataType;
  final Object? value;
  final Object? extraData;
  final bool enabled;
  final ValueChanged<Object?> onChanged;
  final String? errorText;
  final String labelText;

  const _CustomFieldValueEditor({
    required this.labelText,
    required this.dataType,
    required this.value,
    required this.extraData,
    required this.enabled,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return switch (dataType) {
      DataTypeEnum.string => StringFormField(
        labelText: labelText,
        value: value,
        enabled: enabled,
        onChanged: onChanged,
        errorText: errorText,
      ),
      DataTypeEnum.url => UrlFormField(
        value: value,
        enabled: enabled,
        onChanged: onChanged,
        errorText: errorText,
        labelText: labelText,
      ),
      DataTypeEnum.date => DateFormField(
        labelText: labelText,
        errorText: errorText,
        value: value,
        enabled: enabled,
        onChanged: onChanged,
      ),
      DataTypeEnum.boolean => BooleanFormField(
        errorText: errorText,
        labelText: labelText,
        value: value,
        enabled: enabled,
        onChanged: onChanged,
      ),
      DataTypeEnum.integer => IntegerFormField(
        errorText: errorText,
        labelText: labelText,
        value: value,
        enabled: enabled,
        onChanged: onChanged,
      ),
      DataTypeEnum.float => FloatFormField(
        errorText: errorText,
        labelText: labelText,
        value: value,
        enabled: enabled,
        onChanged: onChanged,
      ),
      DataTypeEnum.monetary => MonetaryFormField(
        errorText: errorText,
        labelText: labelText,
        value: value,
        enabled: enabled,
        onChanged: onChanged,
      ),
      DataTypeEnum.documentlink => DocumentLinkFormField(
        errorText: errorText,
        labelText: labelText,
        value: value,
        enabled: enabled,
        onChanged: onChanged,
      ),
      DataTypeEnum.select => SelectFormField(
        errorText: errorText,
        labelText: labelText,
        value: value,
        extraData: extraData,
        enabled: enabled,
        onChanged: onChanged,
      ),
    };
  }
}
