import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_cellular/providers/accumulated_service.dart';
import 'package:pos_cellular/screens/login_screen.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'class/customer.dart';
import 'class/printer.dart';
import 'class/receipt.dart';
import 'class/shared_preferences.dart';
import 'constance.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreference.init();
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(ReceiptAdapter());
  boxReceipt = await Hive.openBox('receiptBox');
  boxCustomer = await Hive.openBox("customerBox");
  var name = UserSimplePreference.getPrinterName();
  var mac = UserSimplePreference.getPrinterMacAddress();
  if(name != null || mac != null){
    Printer.selectedPrinter = BluetoothInfo(name: name, macAdress: mac);
    Printer.connectPrinter();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => AccumulatedService(),),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}


