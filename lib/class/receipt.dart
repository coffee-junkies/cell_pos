
import 'package:hive/hive.dart';
import 'customer.dart';
import 'package:intl/intl.dart';

part 'receipt.g.dart';
@HiveType(typeId: 0)
class Receipt {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String dateAndTime;
  @HiveField(2)
  bool isPayed;
  @HiveField(3)
  final String staffName;
  @HiveField(4)
  final Customer customer;
  @HiveField(5)
  final double payment;
  @HiveField(6)
  final double change;
  @HiveField(7)
  final List<int> serviceAmounts;
  @HiveField(8)
  final List<String> serviceNames;
  @HiveField(9)
  final List<double> servicePrices;
  @HiveField(10)
  final List<double> serviceTotals;
  @HiveField(11)
  final double finalTotal;
  @HiveField(12)
  bool sync = false;

  Receipt({
      required this.id,
      required this.dateAndTime,
      required this.isPayed,
    required this.payment, required this.change,
    required this.staffName,
      required this.customer,
      required this.serviceAmounts,
      required this.serviceNames,
      required this.servicePrices,
      required this.serviceTotals,
      required this.finalTotal});

  setSync(bool sync){
    this.sync = sync;
  }

  List<String> getString() {
    return [
      id.toString(),
      //time
      DateFormat.jm().format(DateTime.parse(dateAndTime)).toString(),
      //year
      DateFormat.y().format(DateTime.parse(dateAndTime)).toString(),
      //month
      DateFormat.MMMM().format(DateTime.parse(dateAndTime)).toString(),
      //day
      DateFormat.d().format(DateTime.parse(dateAndTime)).toString(),
      serviceAmounts.join(",\n").toString(),
      servicePrices.join(",\n").toString(),
      serviceNames.join(",\n").toString(),
      serviceTotals.join(",\n").toString(),
      finalTotal.toString().toString(),
      payment.toString(),
      customer.name,
      customer.contactNumber.toString(),
      staffName,
      isPayed.toString()
    ];
  }
}
