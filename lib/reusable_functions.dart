import 'package:flutter/material.dart';
import 'package:pos_cellular/constance.dart';
import 'package:pos_cellular/providers/accumulated_service.dart';
import 'package:pos_cellular/screens/navigation_drawer.dart';
import 'package:provider/provider.dart';


enum MenuPopUp {clearAllEntry}
enum PopupMenuScreen {ticket, receipt, settings, customersInfo}

popupMenu(BuildContext context, PopupMenuScreen popups){
  if(popups == PopupMenuScreen.ticket){
    return _popupMenuTicket(context);
  }else if(popups == PopupMenuScreen.receipt){
    return _popupMenuReceipt(context);
  }else if(popups == PopupMenuScreen.settings){
    return _popupMenuSettings(context);
  }else{
    return _popupMenuCustomer(context);
  }
}

_popupMenuReceipt(BuildContext context){
  return PopupMenuButton<MenuPopUp>(
    onSelected: (MenuPopUp item) {
      if(item == MenuPopUp.clearAllEntry){
        //TODO clear all receipts
          boxReceipt.clear();
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const NavigationDrawerScreen()));
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuPopUp>>[
      const PopupMenuItem<MenuPopUp>(
        value: MenuPopUp.clearAllEntry,
        child: ListTile(leading: Icon(Icons.delete_forever),
          title: Text("Clear All Data"),),
      ),
    ],
  );
}

_popupMenuTicket(BuildContext context){
  return PopupMenuButton<MenuPopUp>(
    onSelected: (MenuPopUp item) {
      if(item == MenuPopUp.clearAllEntry){
        context.read<AccumulatedService>().resetItemList();
      }
    },

    itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuPopUp>>[
      const PopupMenuItem<MenuPopUp>(
        value: MenuPopUp.clearAllEntry,
        child: ListTile(leading: Icon(Icons.delete_forever),
          title: Text("Clear All Receipt"),),
      ),
    ],
  );
}

_popupMenuSettings(BuildContext context){
  return PopupMenuButton<MenuPopUp>(
    onSelected: (MenuPopUp item) {
      if(item == MenuPopUp.clearAllEntry){
        //TODO reset settings\
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuPopUp>>[
      const PopupMenuItem<MenuPopUp>(
        value: MenuPopUp.clearAllEntry,
        child: ListTile(leading: Icon(Icons.refresh),
          title: Text("Reset Settings"),),
      ),
    ],
  );
}

_popupMenuCustomer(BuildContext context){
  return PopupMenuButton<MenuPopUp>(
    onSelected: (MenuPopUp item) {
      if(item == MenuPopUp.clearAllEntry){
        //TODO clear all data\
        boxCustomer.clear();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const NavigationDrawerScreen()));
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuPopUp>>[
      const PopupMenuItem<MenuPopUp>(
        value: MenuPopUp.clearAllEntry,
        child: ListTile(leading: Icon(Icons.delete_forever),
          title: Text("Delete all item"),),
      ),
    ],
  );
}