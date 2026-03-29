import 'dart:io';

import 'package:flutter/material.dart';

/// A horizontal scrollable list of scanned document thumbnails.
///
/// Each thumbnail can be tapped (for preview) or deleted via a badge button.
class ScanPreviewList extends StatelessWidget {
  final List<File> scans;
  final ValueChanged<int> onDelete;

  const ScanPreviewList({
    super.key,
    required this.scans,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (scans.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 88,
      color: Colors.black54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: scans.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return _ScanThumbnail(
            imageFile: scans[index],
            index: index,
            onDelete: () => onDelete(index),
          );
        },
      ),
    );
  }
}

class _ScanThumbnail extends StatelessWidget {
  final File imageFile;
  final int index;
  final VoidCallback onDelete;

  const _ScanThumbnail({
    required this.imageFile,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.file(
            imageFile,
            width: 56,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        // Page number badge.
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // Delete button.
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
