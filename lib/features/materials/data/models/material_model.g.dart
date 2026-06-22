// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaterialModelAdapter extends TypeAdapter<MaterialModel> {
  @override
  final int typeId = 6;

  @override
  MaterialModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaterialModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      subjectId: fields[3] as String,
      subjectName: fields[4] as String,
      classId: fields[5] as String,
      className: fields[6] as String,
      teacherId: fields[7] as String,
      teacherName: fields[8] as String,
      fileType: fields[9] as String,
      fileUrl: fields[10] as String,
      fileName: fields[11] as String,
      fileSize: fields[12] as int,
      createdAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MaterialModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.subjectId)
      ..writeByte(4)
      ..write(obj.subjectName)
      ..writeByte(5)
      ..write(obj.classId)
      ..writeByte(6)
      ..write(obj.className)
      ..writeByte(7)
      ..write(obj.teacherId)
      ..writeByte(8)
      ..write(obj.teacherName)
      ..writeByte(9)
      ..write(obj.fileType)
      ..writeByte(10)
      ..write(obj.fileUrl)
      ..writeByte(11)
      ..write(obj.fileName)
      ..writeByte(12)
      ..write(obj.fileSize)
      ..writeByte(13)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
