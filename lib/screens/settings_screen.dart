import 'package:flutter/material.dart';
import 'package:pos_cellular/class/shared_preferences.dart';
import 'package:pos_cellular/customers_page.dart';
import 'package:pos_cellular/screens/settings/printer_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool saveReceipt = UserSimplePreference.getSaveSetting() ?? false;
  bool saveClient = UserSimplePreference.getClientSetting() ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Divider(),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PrinterScreen()));
            },
            child: const ListTile( 
              leading: Icon(Icons.print),
              title: Text("Printer"),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text("Receipt"),
            subtitle: const Text("Allow receipts to be saved to your local storage"),
            trailing: Switch(
              value: saveReceipt,
              onChanged: (bool value) {
                setState(() {
                  saveReceipt = value;
                  UserSimplePreference.setSaveReceiptSetting(saveReceipt);
                });
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Client"),
            subtitle: const Text("Allow Client info to be saved into your local storage"),
            trailing: Switch(
              value: saveClient,
              onChanged: (bool value) {
                setState(() {
                  saveClient = value;
                  UserSimplePreference.setClientSetting(saveClient);
                });
              },
            ),
          ),

        ],
      ),
    );
  }
}
