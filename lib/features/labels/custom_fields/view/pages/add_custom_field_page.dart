import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/core/widgets/icon_loading_widget.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class AddCustomFieldPage extends StatelessWidget {
  final String? initialName;
  final Mutation<CustomField, CustomFieldRequest> mutation;

  const AddCustomFieldPage({
    super.key,
    this.initialName,
    required this.mutation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.addCustomField)),
      body: _CustomFieldForm(
        initialName: initialName,
        submitIcon: const Icon(Icons.add),
        submitLabel: Text(S.of(context)!.create),
        mutation: mutation,
      ),
    );
  }
}

class _CustomFieldForm extends StatefulWidget {
  final String? initialName;
  final Widget submitIcon;
  final Widget submitLabel;
  final Mutation<CustomField, CustomFieldRequest> mutation;

  const _CustomFieldForm({
    this.initialName,
    required this.submitIcon,
    required this.submitLabel,
    required this.mutation,
  });

  @override
  State<_CustomFieldForm> createState() => _CustomFieldFormState();
}

class _CustomFieldFormState extends State<_CustomFieldForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, String> _errors = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: MutationBuilder(
        mutation: widget.mutation,
        builder: (context, state, mutate) {
          return FloatingActionButton.extended(
            heroTag: "fab_custom_field_form",
            icon: state.isLoading
                ? const IconLoadingWidget()
                : widget.submitIcon,
            label: widget.submitLabel,
            onPressed: state.isLoading ? null : _onSubmit,
          );
        },
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            FormBuilderTextField(
              autofocus: widget.initialName == null,
              name: 'name',
              decoration: InputDecoration(
                labelText: S.of(context)!.customFieldName,
                errorText: _errors['name'],
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? true) {
                  return S.of(context)!.thisFieldIsRequired;
                }
                return null;
              },
              initialValue: widget.initialName,
              onChanged: (val) => setState(() => _errors = {}),
            ),
            FormBuilderDropdown<DataTypeEnum>(
              name: 'data_type',
              decoration: InputDecoration(
                labelText: S.of(context)!.customFieldDataType,
                errorText: _errors['data_type'],
              ),
              validator: (value) {
                if (value == null) {
                  return S.of(context)!.thisFieldIsRequired;
                }
                return null;
              },
              onChanged: (val) => setState(() => _errors = {}),
              items: DataTypeEnum.values
                  .map(
                    (type) => DropdownMenuItem<DataTypeEnum>(
                      value: type,
                      child: Text(_dataTypeDisplayName(type)),
                    ),
                  )
                  .toList(),
            ),
          ].padded(),
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      try {
        final formState = _formKey.currentState!;
        final request = CustomFieldRequest(
          name: formState.value['name'] as String,
          dataType: formState.value['data_type'] as DataTypeEnum,
        );
        final mutationResult = await widget.mutation.mutate(request);
        if (mutationResult is MutationError) {
          throw (mutationResult as MutationError).error;
        }
        if (mounted) context.pop(mutationResult.data);
      } on PaperlessApiException catch (error, stackTrace) {
        if (mounted) showErrorMessage(context, error, stackTrace);
      } on PaperlessFormValidationException catch (exception) {
        setState(() => _errors = exception.validationMessages);
      } catch (error, stackTrace) {
        if (mounted) {
          showGenericError(context, error, stackTrace);
        }
      }
    }
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
}
