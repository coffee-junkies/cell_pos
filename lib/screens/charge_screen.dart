import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pos_cellular/class/shared_preferences.dart';
import 'package:pos_cellular/constance.dart';
import 'package:pos_cellular/providers/accumulated_service.dart';
import 'package:pos_cellular/utils/g_sheet_adapter.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import '../class/customer.dart';
import '../class/printer.dart';
import '../class/receipt.dart';

class ChargeScreen extends StatefulWidget {
  const ChargeScreen({super.key});

  @override
  State<ChargeScreen> createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  bool isExisting = false;
  TextEditingController name = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  bool isInCharge = false;
  TextEditingController amount = TextEditingController();
  FocusNode nodeAmount = FocusNode();
  Printer printer = Printer();
  Receipt? receipt;

  @override
  void dispose() {
    name.dispose();
    amount.dispose();
    contactNumber.dispose();
    nodeAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitDialog();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton( 
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              _showExitDialog();
            },
          ),
          title: const Text("Charge"),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: _getWidget()),
        ),
      ),
    );
  }

  _printButton(bool ifPayed) async {
    //check if amount is greater or equal to charge
    if (ifPayed) {
      if (amount.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Enter Amount Received")));
        return;
      }
      if (double.parse(amount.text) <
          context.read<AccumulatedService>().totalCharge) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insufficient Amount")));
        return;
      }
      context.read<AccumulatedService>().setPayment(double.parse(amount.text));
      context.read<AccumulatedService>().setChange(double.parse(amount.text));
    }

    FocusScope.of(context).unfocus();
    if (context.read<AccumulatedService>().receipt == null) {
      context.read<AccumulatedService>().createReceipt(ifPayed);
    }
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    await _saveToGSheet();
    if(!mounted)return;
    Navigator.of(context).pop();

    _showPrintDialog(ifPayed);
    if (UserSimplePreference.getSaveSetting() ?? false) {
      _saveToDatabase();
    }
    if (UserSimplePreference.getClientSetting() ?? false) {
      _saveClientInfo();
    }
  }

  _printFunction(bool ifPayed) async {
    if (ifPayed) {
      List<int> ticket = await Printer.printCashTicket(
          context.read<AccumulatedService>().receipt!);
      await PrintBluetoothThermal.writeBytes(ticket);
    } else {
      List<int> ticket = await Printer.printCreditTicket(
          context.read<AccumulatedService>().receipt!);
      await PrintBluetoothThermal.writeBytes(ticket);
    }
  }

  _saveToDatabase() {
    Receipt receipt = context.read<AccumulatedService>().receipt!;
    boxReceipt.put(receipt.id, receipt);
  }

  _saveClientInfo() {
    Customer customer = context.read<AccumulatedService>().customer!;
    boxCustomer.put(customer.contactNumber, customer);
  }

  _saveToGSheet() async {
    ReceiptSheetApi.receiptSheet = null;
    bool success = await ReceiptSheetApi.init();
    //successfully connect to g_spreadsheet
    if (success) {
      if (!mounted) return;
      bool receiptSend = await ReceiptSheetApi.insertViaReceipt(
          context.read<AccumulatedService>().receipt!.getString());
      //successfully inserted to g_sheet
      if (receiptSend) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Successfully Send")));
        //failed to insert data to spreadsheet
      } else {
        if (!mounted) return;
        await _showErrorDialog();
      }
      //failed to connect to g_spreadsheet
    } else {
      if (!mounted) return;
      await _showErrorDialog();
    }
  }

  _getWidget() {
    if (isInCharge) {
      return _chargeWidget();
    } else {
      return _customersInfoWidget();
    }
  }

  _chargeWidget() {
    FocusScope.of(context).requestFocus(nodeAmount);
    return Column(
      children: [
        const Text("Amount to pay"),
        const Gap(10),
        Text(
          context.read<AccumulatedService>().totalCharge.toString(),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const Gap(10),
        TextField(
          textAlign: TextAlign.center,
          controller: amount,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              floatingLabelAlignment: FloatingLabelAlignment.center,
              label: Center(
                child: Text("Enter Amount Received"),
              )),
        ),
        const Gap(20),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _printButton(true);
                },
                child: const Text("Print Receipt"))),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _printButton(false);
                },
                child: const Text("Print Invoice"))),
      ],
    );
  }

  _customersInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Customers Info",
          style: kLoginText,
        ),
        const Gap(15),
        TextField(
          controller: name,
          autofocus: true,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "Name"),
        ),
        const Gap(15),
        TextField(
          controller: contactNumber,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "Contact No."),
        ),
        const Gap(15),
        SizedBox(
          height: 50,
          child: ElevatedButton(
              onPressed: () {
                if (name.text.isNotEmpty && contactNumber.text.isNotEmpty) {
                  Customer customer = Customer(
                      name: name.text, contactNumber: contactNumber.text);
                  context.read<AccumulatedService>().setCustomer(customer);
                  setState(() {
                    isInCharge = true;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please fill-up all empty fields")));
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: const Text("Payment")),
        )
      ],
    );
  }

  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Cannot connect to the internet.'),
                Text('would you like to try again?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveToGSheet();
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("No"))
          ],
        );
      },
    );
  }

  Future<void> _showPrintDialog(bool ifPayed) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Print'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to print Receipt?.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _printFunction(ifPayed);
              },
              child: const Text('Yes'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  context.read<AccumulatedService>().resetItemList();
                },
                child: const Text("No"))
          ],
        );
      },
    );
  }

  Future<void> _showExitDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text("Void Order")),
            content: const SingleChildScrollView(
              child: Column(children: [
                Text("Are you sure you want"),
                Text("to void this order?"),
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<AccumulatedService>().resetItemList();
                    Navigator.pop(context);
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }
}
