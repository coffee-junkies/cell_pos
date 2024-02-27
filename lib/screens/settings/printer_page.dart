import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../../class/printer.dart';
import '../../class/shared_preferences.dart';

class PrinterScreen extends StatefulWidget {
  const PrinterScreen({super.key});

  @override
  State<PrinterScreen> createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  String printerName = UserSimplePreference.getPrinterName() ?? "None";
  String macAddress = UserSimplePreference.getPrinterMacAddress() ?? "";
  bool bluetoothStatus = false;

  @override
  initState() {

    checkPermissions();
    super.initState();
  }

  checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
    bool state = await PrintBluetoothThermal.bluetoothEnabled;
    setState(() {
      bluetoothStatus = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Printer"),
          ),
          body: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.bluetooth_connected),
                title: Text("Bluetooth permission: $bluetoothStatus"),
                trailing: IconButton(
                  onPressed: () async {
                    if (bluetoothStatus) return;
                    bool state = await PrintBluetoothThermal.bluetoothEnabled;
                    setState(() {
                      bluetoothStatus = state;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.print),
                title: Text("Printer Name : $printerName"),
                subtitle: Text("Mac Address: $macAddress"),
                trailing: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async{
                    await _showBluetoothDevices();
                    if(!mounted)return;
                    showDialog(
                        context: context,
                        builder: (context) => const Center(child: CircularProgressIndicator()));
                    setState(() {
                      printerName = UserSimplePreference.getPrinterName();
                      macAddress = UserSimplePreference.getPrinterMacAddress();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                    onPressed: () {
                      Printer.testPrint();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      )
                    ),
                    child: const Text("Test printer")),
              )
            ],
          )),
    );
  }

  Future<void> _showBluetoothDevices() async{
    await Printer.searchPrinters();
    if(!mounted)return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connected Device'),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 250,
              width: 200,
              child: ListView.builder(
                  itemCount: Printer.listResult.length,
                  itemBuilder: (BuildContext context, int index){
                    BluetoothInfo device = Printer.listResult[index];
                return GestureDetector(
                  onTap: (){
                    Printer.disconnect();
                    Printer.selectedPrinter = device;
                    Printer.connectPrinter();
                    UserSimplePreference.setPrinter(printerName: device.name, printerMacAddress: device.macAdress);
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.bluetooth_connected),
                    title: Text(device.name),
                    subtitle: Text(device.macAdress),
                  ),
                );
              }),
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text("Cancel"))
          ],
        );
      },
    );
  }
}
