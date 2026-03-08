import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/custom_field_icon_mappings.dart';

class CustomFieldSelectionPage extends StatefulWidget {
  final List<int> excludeFieldIds;
  const CustomFieldSelectionPage({super.key, required this.excludeFieldIds});

  @override
  State<CustomFieldSelectionPage> createState() =>
      _CustomFieldSelectionPageState();
}

class _CustomFieldSelectionPageState extends State<CustomFieldSelectionPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Hero(
          tag: "search_custom_fields_hero_tag",
          child: TextField(
            autofocus: true,
            // style: theme.textTheme.bodyLarge?.apply(
            //   color: theme.colorScheme.onSurface,
            // ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: 'Search custom fields',
              border: InputBorder.none,
            ),
            controller: _controller,
            textInputAction: TextInputAction.search,
          ),
        ),
      ),
      body: QueryBuilder(
        query: context.customFieldRepository.getAllQuery(),
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isError) {
            return const Center(child: Text('Error loading custom fields'));
          }
          final customFields = state.data ?? [];
          final prefilteredCustomFields = customFields
              .where((cf) => !widget.excludeFieldIds.contains(cf.id))
              .toList();
          final filteredCustomFields = prefilteredCustomFields
              .where(
                (cf) => cf.name.toLowerCase().contains(
                  _controller.text.toLowerCase(),
                ),
              )
              .toList();
          return ListView.builder(
            itemCount: filteredCustomFields.length,
            itemBuilder: (context, index) {
              final field = filteredCustomFields[index];
              if (widget.excludeFieldIds.contains(field.id)) {
                return const SizedBox.shrink();
              }
              return ListTile(
                title: Text(field.name),
                leading: Icon(getCustomFieldIcon(field.dataType)),
                onTap: () {
                  context.pop(field);
                },
              );
            },
          );
        },
      ),
    );
  }
}
