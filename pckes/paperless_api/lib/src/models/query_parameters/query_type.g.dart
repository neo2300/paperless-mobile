// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueryTypeAdapter extends TypeAdapter<QueryType> {
  @override
  final int typeId = 115;

  @override
  QueryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QueryType.title;
      case 1:
        return QueryType.titleAndContent;
      case 2:
        return QueryType.extended;
      case 3:
        return QueryType.asn;
      default:
        return QueryType.title;
    }
  }

  @override
  void write(BinaryWriter writer, QueryType obj) {
    switch (obj) {
      case QueryType.title:
        writer.writeByte(0);
        break;
      case QueryType.titleAndContent:
        writer.writeByte(1);
        break;
      case QueryType.extended:
        writer.writeByte(2);
        break;
      case QueryType.asn:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
