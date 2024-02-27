import 'package:hive/hive.dart';
part 'customer.g.dart';
@HiveType(typeId: 1)
class Customer{
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String contactNumber;
  @HiveField(2)
  int _numberOfLoads = 0;
  Customer({required this.name, required this.contactNumber});
  getNumberOfLoads()=>_numberOfLoads;
  setNumberOfLoads(int loads) => _numberOfLoads = loads;
}