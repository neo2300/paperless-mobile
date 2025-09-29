// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_field.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SortFieldAdapter extends TypeAdapter<SortField> {
  @override
  final int typeId = 108;

  @override
  SortField read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortField.archiveSerialNumber;
      case 1:
        return SortField.correspondentName;
      case 2:
        return SortField.title;
      case 3:
        return SortField.documentType;
      case 4:
        return SortField.created;
      case 5:
        return SortField.added;
      case 6:
        return SortField.modified;
      case 7:
        return SortField.score;
      default:
        return SortField.archiveSerialNumber;
    }
  }

  @override
  void write(BinaryWriter writer, SortField obj) {
    switch (obj) {
      case SortField.archiveSerialNumber:
        writer.writeByte(0);
        break;
      case SortField.correspondentName:
        writer.writeByte(1);
        break;
      case SortField.title:
        writer.writeByte(2);
        break;
      case SortField.documentType:
        writer.writeByte(3);
        break;
      case SortField.created:
        writer.writeByte(4);
        break;
      case SortField.added:
        writer.writeByte(5);
        break;
      case SortField.modified:
        writer.writeByte(6);
        break;
      case SortField.score:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortFieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
