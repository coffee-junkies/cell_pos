import 'package:flutter/material.dart';
import 'package:pos_cellular/customers_page.dart';
import 'package:pos_cellular/providers/accumulated_service.dart';
import 'package:pos_cellular/screens/receipt_screen.dart';
import 'package:pos_cellular/screens/sales_screen.dart';
import 'package:pos_cellular/screens/settings_screen.dart';
import 'package:pos_cellular/screens/ticket_screen.dart';
import 'package:provider/provider.dart';
import '../reusable_functions.dart';

class NavigationDrawerScreen extends StatefulWidget {
  const NavigationDrawerScreen({super.key});

  @override
  State<NavigationDrawerScreen> createState() => _NavigationDrawerScreenState();
}

class _NavigationDrawerScreenState extends State<NavigationDrawerScreen> {
  int numberOfItem = 0;
  late String appBarTitle;
  int _selectedIndex = 0;
  PopupMenuScreen? popupMenuScreen;

  static List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getAppBarTitle(){
    if(_selectedIndex == 0){
      popupMenuScreen = PopupMenuScreen.ticket;
      return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketScreen()));
          },
          child: Text("$appBarTitle $numberOfItem"));
    }else if(_selectedIndex == 1){
      popupMenuScreen = PopupMenuScreen.receipt;
      return Text(appBarTitle);
    }else if(_selectedIndex == 2){
      popupMenuScreen = PopupMenuScreen.settings;
      return Text(appBarTitle);
    }else{
      popupMenuScreen = PopupMenuScreen.customersInfo;
      return Text(appBarTitle);
    }
  }

  @override
  void initState() {
    popupMenuScreen = PopupMenuScreen.ticket;
    appBarTitle = "Ticket";
    _widgetOptions = [const SalesScreen(),
      const ReceiptScreen(),
      const SettingsScreen(),
    const CustomersPage()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    numberOfItem = context.watch<AccumulatedService>().ticket;
    return Scaffold(
      appBar: AppBar(
        title: _getAppBarTitle(),
        actions: [
          popupMenu(context, popupMenuScreen!)
        ],
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text('WASHBOX'),
            ),
            ListTile(
              title: const Text('Sales'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                appBarTitle = "Ticket";
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Receipt'),
              selected: _selectedIndex == 1,
              onTap: () {
                appBarTitle = "Receipt";
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Customer\'s Info'),
              selected: _selectedIndex == 3,
              onTap: () {
                appBarTitle = "Customers Info";
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              selected: _selectedIndex == 2,
              onTap: () {
                appBarTitle = "Settings";
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
    )
    ;
  }


}
