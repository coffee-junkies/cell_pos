import 'package:pos_cellular/class/receipt.dart';
import '../class/customer.dart';
import '../class/items_received.dart';
import 'package:flutter/material.dart';

class AccumulatedService extends ChangeNotifier {
  Map<String, ItemReceived> items = {};
  String staffName = "";
  Customer? customer;
  int ticket = 0;
  double discount = 0;
  double totalCharge = 0;
  double change = 0;
  double payment = 0;
  String paymentMethod = "cash";
  List<String> paymentMethods = ["cash", "credit", "g-cash"];
  List<int> serviceAmounts = [];
  List<String> serviceNames = [];
  List<double> servicePrices = [];
  List<double> serviceTotals = [];
  Receipt? receipt;
  AccumulatedService();

  void addItem({required ItemReceived itemReceived}) async {
    items[itemReceived.item.service] = itemReceived;
    notifyListeners();
  }

  void addTicket() {
    ticket++;
    notifyListeners();
  }

  void deleteItem({required ItemReceived itemReceived}) {
    items.remove(itemReceived.item.service);
    notifyListeners();
  }

  void createReceipt(bool isPayed) {
    setServiceReceipt();
    DateTime dT = DateTime.now();
    String id = "${dT.year}${dT.month}${dT.day}-${dT.hour}-${dT.minute}-${dT.second}";
    receipt = Receipt(id: id,
        dateAndTime: dT.toString(),
        change: change,
        payment: payment,
        isPayed: isPayed,
        staffName: staffName,
        customer: customer!,
        serviceAmounts: serviceAmounts,
        serviceNames: serviceNames,
        servicePrices: servicePrices,
        serviceTotals: serviceTotals,
        finalTotal: totalCharge);
  }

  getAmount(String name) {
    if (items[name] == null) return "";
    return items[name]?.amount;
  }

  void addTotalCharge(double charge) {
    totalCharge += charge;
    notifyListeners();
  }
  
  void calculateTotalCharge(){
    totalCharge = 0;
    items.values.map((e) => addTotalCharge(e.amount * e.item.price)).toList();
    notifyListeners();
  }

  void resetItemList() {
    items.clear();
    ticket = 0;
    totalCharge = 0;
    discount = 0;
    customer = null;
    serviceAmounts.clear();
    serviceNames.clear();
    servicePrices.clear();
    serviceTotals.clear();
    receipt = null;
    payment = 0;
    notifyListeners();
  }

  void setFinalTotal() {
    totalCharge = ticket - discount;
    notifyListeners();
  }

  void setPayment(double pay){
    payment = pay;
    notifyListeners();
  }

  void setCustomer(Customer customer) {
    this.customer = customer;
    notifyListeners();
  }

  void setChange(double payment){
    change = totalCharge - payment;
    notifyListeners();
  }

  setServiceReceipt(){
    items.values.map((e) {
      int amt = e.amount;
      double prc = e.item.price;
      serviceAmounts.add(amt);
      serviceNames.add(e.item.service);
      servicePrices.add(prc);
      serviceTotals.add(amt*prc);
    }).toList();
  }

  void updateItemListAdd(ItemReceived itemReceived) {
    String name = itemReceived.item.service;
    if (items[name] == null) {
      addItem(itemReceived: itemReceived);
      return;
    } else {
      int amount = items[name]!.amount + 1;
      items.update(name,
              (value) => ItemReceived(amount: amount, item: itemReceived.item));
    }
    notifyListeners();
  }

  void updateItemListSubTract(ItemReceived itemReceived) {
    String name = itemReceived.item.service;
    if (items[name] == null) return;
    int amount = items[name]!.amount - 1;
    items.update(
        name, (value) => ItemReceived(amount: amount, item: itemReceived.item));
    if (items[name]?.amount == 0) {
      deleteItem(itemReceived: itemReceived);
    }
    notifyListeners();
  }

}
