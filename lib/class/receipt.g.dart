// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceiptAdapter extends TypeAdapter<Receipt> {
  @override
  final int typeId = 0;

  @override
  Receipt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Receipt(
      id: fields[0] as String,
      dateAndTime: fields[1] as String,
      isPayed: fields[2] as bool,
      payment: fields[5] as double,
      change: fields[6] as double,
      staffName: fields[3] as String,
      customer: fields[4] as Customer,
      serviceAmounts: (fields[7] as List).cast<int>(),
      serviceNames: (fields[8] as List).cast<String>(),
      servicePrices: (fields[9] as List).cast<double>(),
      serviceTotals: (fields[10] as List).cast<double>(),
      finalTotal: fields[11] as double,
    )..sync = fields[12] as bool;
  }

  @override
  void write(BinaryWriter writer, Receipt obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateAndTime)
      ..writeByte(2)
      ..write(obj.isPayed)
      ..writeByte(3)
      ..write(obj.staffName)
      ..writeByte(4)
      ..write(obj.customer)
      ..writeByte(5)
      ..write(obj.payment)
      ..writeByte(6)
      ..write(obj.change)
      ..writeByte(7)
      ..write(obj.serviceAmounts)
      ..writeByte(8)
      ..write(obj.serviceNames)
      ..writeByte(9)
      ..write(obj.servicePrices)
      ..writeByte(10)
      ..write(obj.serviceTotals)
      ..writeByte(11)
      ..write(obj.finalTotal)
      ..writeByte(12)
      ..write(obj.sync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
