import 'package:flutter/material.dart';

class DocumentLinkFullscreenSelection extends StatefulWidget {
  const DocumentLinkFullscreenSelection({super.key});

  @override
  State<DocumentLinkFullscreenSelection> createState() =>
      _DocumentLinkFullscreenSelectionState();
}

class _DocumentLinkFullscreenSelectionState
    extends State<DocumentLinkFullscreenSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kMinInteractiveDimension),
        child: SearchBar(),
      ),
    );
  }
}
