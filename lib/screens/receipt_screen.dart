import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pos_cellular/class/receipt.dart';
import 'package:pos_cellular/constance.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:url_launcher/url_launcher.dart';
import '../class/printer.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  List<Receipt> receipts = [];

  @override
  void initState() {
    boxReceipt.values.map((e) => receipts.add(e)).toList();
    receipts = receipts.reversed.toList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }
  _bodyWidget(){
    if(receipts.isNotEmpty){
      return ListView.builder(
          itemCount: receipts.length,
          itemBuilder: (BuildContext context, int index){
            Receipt receipt = receipts[index];
            return Card(
              child: Slidable(
                key: ValueKey(index),
                startActionPane: ActionPane(
                  extentRatio:1,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed:(context){
                        boxReceipt.delete(receipt.id);
                        setState(() {
                          receipts.removeAt(index);
                        });
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        if (receipt.isPayed) {
                          List<int> ticket = await Printer.printCashTicket(
                              receipt);
                          await PrintBluetoothThermal.writeBytes(ticket);
                        } else {
                          List<int> ticket = await Printer.printCreditTicket(
                              receipt);
                          await PrintBluetoothThermal.writeBytes(ticket);
                        }
                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.print,
                      label: 'Print',
                    ),
                    SlidableAction(
                      // An action can be bigger than the others.
                      onPressed: (context)async{
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: receipt.customer.contactNumber,
                        );
                        await launchUrl(launchUri);
                      },
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.call,
                      label: 'Call',
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        String message = "";
                        try {
                          await launch(
                              'sms:${receipt.customer.contactNumber} ?body=$message');
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.message,
                      label: 'SMS',
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Text(receipt.id),
                  title: Text(receipt.customer.name),
                  subtitle: Text(receipt.customer.contactNumber),
                  trailing: Text("P${receipt.finalTotal}"),
                ),
              ),
            );
          });
    }else{
      return const Center(
        child: Text("No Receipts saved"),
      );
    }
  }
  _getAllReceipts(){}
  _getTodayReceipts(){}
  _getSelectedDateReceipts(){}
  
}
