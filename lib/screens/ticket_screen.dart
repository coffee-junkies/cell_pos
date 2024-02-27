import 'package:flutter/material.dart';
import 'package:pos_cellular/class/items_received.dart';
import 'package:pos_cellular/constance.dart';
import 'package:pos_cellular/providers/accumulated_service.dart';
import 'package:provider/provider.dart';

import '../reusable_functions.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  MenuPopUp? selectedMenu;

  @override
  Widget build(BuildContext context) {
    Map<String, ItemReceived> items = context
        .watch<AccumulatedService>()
        .items;
    return Scaffold(
      appBar: AppBar(title: const Text("Receipt"),actions: [
        popupMenu(context, PopupMenuScreen.ticket)
      ],),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: context
                    .read<AccumulatedService>()
                    .items
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  ItemReceived item = items.values.elementAt(index);
                  return Dismissible(
                    key: ObjectKey(item),
                    onDismissed: (direction){
                      context.read<AccumulatedService>().deleteItem(itemReceived: item);
                      context.read<AccumulatedService>().calculateTotalCharge();
                    },
                    child: ListTile(
                      leading: Text(item.amount.toString(), style: kLoginText,),
                      title: Text(item.item.service),
                      subtitle: Text(item.item.price.toString()),
                      trailing: Text((item.amount * item.item.price).toString(),
                        style: kLoginText,),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("TOTAL: ", style: kLoginText),
                  Text(context
                      .watch<AccumulatedService>()
                      .totalCharge
                      .toString(), style: kLoginText,)
                ]
            ),
          )
        ],
      ),
    );
  }


}
