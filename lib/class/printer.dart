import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';
import 'package:pos_cellular/class/receipt.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';



class Printer{

  static List<BluetoothInfo> listResult = [];
  static BluetoothInfo? selectedPrinter;


  Printer(){
    searchPrinters();
  }

  static Future<void> searchPrinters() async {
    listResult = await PrintBluetoothThermal.pairedBluetooths;
  }

  static Future<bool> connectPrinter() async {
    bool isConnected = await PrintBluetoothThermal.connect(
        macPrinterAddress: selectedPrinter!.macAdress);
    return isConnected;
  }

  static Future<bool> disconnect() async{
    return await PrintBluetoothThermal.disconnect;
  }

  static Future<List<int>> printCashTicket(Receipt receipt) async {
    String t = DateFormat.jm().format(DateTime.parse(receipt.dateAndTime));
    final List<String> qrData = receipt.getString();
    List tim = t.split(RegExp(r'\s'));
    String time = "${tim[0]} ${tim[1]} ";
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();
    bytes += generator.text('RECEIPT OF SALE', styles: const PosStyles(bold: true, align: PosAlign.center ));
    bytes += generator.text('WASHBOX', styles: const PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2, ));
    bytes += generator.text('ID: ${receipt.id}', styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontA));
    bytes += generator.text(receipt.customer.name, styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontA));
    bytes += generator.text('Phone#:  ${receipt.customer.contactNumber}', styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontA,));
    bytes += generator.text("Staff: ${receipt.staffName}", styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontB), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: DateFormat.yMMMd().format(DateTime.parse(receipt.dateAndTime)),
        width: 6,
        styles: const PosStyles(align: PosAlign.center,fontType: PosFontType.fontA),
      ),
      PosColumn(
        text: time.trim(),
        width: 6,
        styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontA),
      ),
    ]);

    bytes += generator.text("",linesAfter: 1);
    bytes += generator.row([
      PosColumn(
        text: 'UP',
        width: 3,
        styles: const PosStyles(align: PosAlign.left ,fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: 'ITEM',
        width: 6,
        styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: 'AMT',
        width: 3,
        styles: const PosStyles(align: PosAlign.right, fontType: PosFontType.fontB),
      ),
    ]);
    bytes += generator.text('--------------------------------', styles: const PosStyles(fontType: PosFontType.fontA), linesAfter: 1);
    for(int index = 0; index < receipt.serviceNames.length; index++ ){
      bytes += generator.row([
        PosColumn(
          text: receipt.servicePrices[index].toString(),
          width: 3,
          styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),
        ),
        PosColumn(
          text: "${receipt.serviceNames[index]} x ${receipt.serviceAmounts[index]}",
          width: 6,
          styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),
        ),
        PosColumn(
          text: "${receipt.serviceTotals[index]}",
          width: 3,
          styles: const PosStyles(align: PosAlign.right,fontType: PosFontType.fontA),
        ),
      ]);
    }
    bytes += generator.text('--------------------------------', styles: const PosStyles(fontType: PosFontType.fontA), linesAfter: 1);
    bytes += generator.row([
      PosColumn(
        text: "Discount",
        width: 12,
        styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: "Total",
        width: 6,
        styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),
      ),
      PosColumn(
        text: receipt.finalTotal.toString(),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, fontType: PosFontType.fontA),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Cash",
        width: 6,
        styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),
      ),
      PosColumn(
        text: receipt.payment.toString(),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, fontType: PosFontType.fontA),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: "Change",
        width: 6,
        styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),
      ),
      PosColumn(
        text: receipt.change.toString(),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, fontType: PosFontType.fontA),
      ),
    ]);
    bytes += generator.text('--------------------------------', linesAfter: 1);

    bytes += generator.text('Thank You', styles: const PosStyles(bold: true, align: PosAlign.center ));


    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  static Future<void> printTicket(Receipt receipt) async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
        List<int> ticket = await printCashTicket(receipt);
        await PrintBluetoothThermal.writeBytes(ticket);
    }
  }

  static Future<List<int>> printCreditTicket(Receipt receipt) async {
    String t = DateFormat.jm().format(DateTime.parse(receipt.dateAndTime));
    List tim = t.split(RegExp(r'\s'));
    String time = "${tim[0]} ${tim[1]} ";

    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();
    bytes += generator.text('INVOICE', styles: const PosStyles(bold: true, align: PosAlign.center ));
    bytes += generator.text('WASHBOX', styles: const PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2, ));
    bytes += generator.text('ID: ${receipt.id}', styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontA));
    bytes += generator.text(receipt.customer.name, styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    bytes += generator.text('Phone#:  ${receipt.customer.contactNumber}', styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontA,));
    bytes += generator.text("Staff: ${receipt.staffName}", styles: const PosStyles(align: PosAlign.center, fontType: PosFontType.fontB), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: DateFormat.yMMMd().format(DateTime.parse(receipt.dateAndTime)),
        width: 6,
        styles: const PosStyles(align: PosAlign.center,fontType: PosFontType.fontA),
      ),
      PosColumn(
        text: time,
        width: 6,
        styles: const PosStyles(align: PosAlign.left, fontType: PosFontType.fontA),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'UP',
        width: 3,
        styles: const PosStyles(align: PosAlign.left ,fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: 'ITEM',
        width: 6,
        styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontB),
      ),
      PosColumn(
        text: 'AMT',
        width: 3,
        styles: const PosStyles(align: PosAlign.right, fontType: PosFontType.fontB),
      ),
    ]);
    bytes += generator.text('--------------------------------', styles: const PosStyles(fontType: PosFontType.fontA), linesAfter: 1);
    for(int index = 0; index < receipt.serviceNames.length; index++ ){
      bytes += generator.row([
        PosColumn(
          text: receipt.servicePrices[index].toString(),
          width: 3,
          styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),
        ),
        PosColumn(
          text: "${receipt.serviceNames[index]} x ${receipt.serviceAmounts[index]}",
          width: 6,
          styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),
        ),
        PosColumn(
          text: "${receipt.serviceTotals[index]}",
          width: 3,
          styles: const PosStyles(align: PosAlign.right,fontType: PosFontType.fontA),
        ),
      ]);
    }

    bytes += generator.text('--------------------------------', styles: const PosStyles(fontType: PosFontType.fontA), linesAfter: 1);
    bytes += generator.row([
      PosColumn(
        text: "Total",
        width: 6,
        styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontA),
      ),
      PosColumn(
        text: receipt.finalTotal.toString(),
        width: 6,
        styles: const PosStyles(align: PosAlign.right, fontType: PosFontType.fontA),
      ),
    ]);

    bytes += generator.text('--------------------------------', linesAfter: 1);
    bytes += generator.text('Thank You', styles: const PosStyles(bold: true, align: PosAlign.center ));
    bytes += generator.text('Please pay before getting your laundry', styles: const PosStyles(bold: true, align: PosAlign.center ));
    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  static Future<void> testPrint()async{
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      List<int> ticket = await testReceipt();
      await PrintBluetoothThermal.writeBytes(ticket);
    }
  }

  static Future<List<int>> testReceipt() async{
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();
    bytes += generator.text('RECEIPT OF SALE', styles: const PosStyles(bold: true, align: PosAlign.center ));
    bytes += generator.text('WASHBOX', styles: const PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2, ));
    bytes += generator.text('THIS IS A TEST', styles: const PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2, ));
    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }
}