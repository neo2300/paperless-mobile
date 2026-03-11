// //
// // AUTO-GENERATED FILE, DO NOT MODIFY!
// //

// // ignore_for_file: unused_element
// import 'package:paperless_mobile/api/models/matching_algorithm.dart';
// import 'package:copy_with_extension/copy_with_extension.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:equatable/src/equatable_utils.dart';

// part 'storage_path.g.dart';

// @CopyWith()
// @JsonSerializable(
//   checked: true,
//   createToJson: true,
//   disallowUnrecognizedKeys: false,
//   explicitToJson: true,
// )
// class StoragePath {
//   /// Returns a new [StoragePath] instance.
//   StoragePath({
//     required this.id,

//     required this.slug,

//     required this.name,

//     required this.path,

//     this.match,

//     this.matchingAlgorithm,

//     this.isInsensitive,

//     required this.documentCount,

//     this.owner,

//     required this.userCanChange,
//   });

//   @JsonKey(name: r'id',  includeIfNull: false)
//   final int id;

//   @JsonKey(name: r'slug',  includeIfNull: false)
//   final String slug;

//   @JsonKey(name: r'name',  includeIfNull: false)
//   final String name;

//   @JsonKey(name: r'path',  includeIfNull: false)
//   final String path;

//   @JsonKey(name: r'match',  includeIfNull: false)
//   final String? match;

//   // minimum: 0.0
//   // maximum: 2.147483647E9
//   @JsonKey(name: r'matching_algorithm',  includeIfNull: false)
//   final MatchingAlgorithm? matchingAlgorithm;

//   @JsonKey(name: r'is_insensitive',  includeIfNull: false)
//   final bool? isInsensitive;

//   @JsonKey(name: r'document_count',  includeIfNull: false)
//   final int documentCount;

//   @JsonKey(name: r'owner',  includeIfNull: false)
//   final int? owner;

//   @JsonKey(name: r'user_can_change',  includeIfNull: false)
//   final bool userCanChange;

//   @override
//   bool operator ==(Object other) {
//     return identical(this, other) ||
//         other is StoragePath &&
//             runtimeType == other.runtimeType &&
//             equals(
//               [
//                 id,
//                 slug,
//                 name,
//                 path,
//                 match,
//                 matchingAlgorithm,
//                 isInsensitive,
//                 documentCount,
//                 owner,
//                 userCanChange,
//               ],
//               [
//                 other.id,
//                 other.slug,
//                 other.name,
//                 other.path,
//                 other.match,
//                 other.matchingAlgorithm,
//                 other.isInsensitive,
//                 other.documentCount,
//                 other.owner,
//                 other.userCanChange,
//               ],
//             );
//   }

//   @override
//   int get hashCode =>
//       runtimeType.hashCode ^
//       mapPropsToHashCode([
//         id,
//         slug,
//         name,
//         path,
//         match,
//         matchingAlgorithm,
//         isInsensitive,
//         documentCount,
//         owner,
//         userCanChange,
//       ]);

//   factory StoragePath.fromJson(Map<String, dynamic> json) =>
//       _$StoragePathFromJson(json);

//   Map<String, dynamic> toJson() => _$StoragePathToJson(this);

//   @override
//   String toString() {
//     return toJson().toString();
//   }
// }
