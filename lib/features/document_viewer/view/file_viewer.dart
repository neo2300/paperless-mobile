import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:pdfrx/pdfrx.dart';

class FileViewer extends StatelessWidget {
  final FutureOr<Uint8List> Function(BuildContext context) fileProvider;
  final Axis scrollDirection;
  const FileViewer({
    super.key,
    required this.fileProvider,
    required this.scrollDirection,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: Future.value(fileProvider(context)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return _LoadedFileViewer(
          bytes: snapshot.data!,
          scrollDirection: scrollDirection,
        );
      },
    );
  }
}

class _LoadedFileViewer extends StatefulWidget {
  final Uint8List bytes;
  final Axis scrollDirection;

  const _LoadedFileViewer({
    required this.bytes,
    required this.scrollDirection,
  });

  @override
  State<_LoadedFileViewer> createState() => _LoadedFileViewerState();
}

class _LoadedFileViewerState extends State<_LoadedFileViewer> {
  int _currentPage = 1;
  int? _totalPages;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageTransitionDuration = MediaQuery.disableAnimationsOf(context)
        ? 0.milliseconds
        : 100.milliseconds;

    return Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        body: PdfViewer.data(widget.bytes, sourceName: ''));
  }
}
