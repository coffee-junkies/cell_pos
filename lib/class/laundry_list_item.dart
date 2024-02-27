import 'laundry_service.dart';

class LaundryListItems extends LaundryService{
  final double weight;
  late double rate;
  LaundryListItems({required this.weight, required super.service, required super.price, required super.unit, required super.category}){
    rate = weight * price;
  }
}