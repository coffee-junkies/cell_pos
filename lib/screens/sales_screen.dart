import 'package:flutter/material.dart';
import 'package:pos_cellular/constance.dart';
import 'package:pos_cellular/providers/accumulated_service.dart';
import 'package:pos_cellular/screens/charge_screen.dart';
import 'package:provider/provider.dart';
import '../class/items_received.dart';
import '../class/laundry_service.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String dropdownValue = kCategories.first;
  List<LaundryService> serviceList = [];

  @override
  void initState() {
    getAllList();
    super.initState();
  }

  getAllList() {
    serviceList.addAll(kLaundryServicesFull);
    serviceList.addAll(kLaundryServicesPartial);
    serviceList.addAll(kLaundryServicesCommodities);
  }

  getFullServiceList() => serviceList.addAll(kLaundryServicesFull);

  getPartialServiceList() => serviceList.addAll(kLaundryServicesPartial);

  getCommoditiesList() => serviceList.addAll(kLaundryServicesCommodities);

  @override
  Widget build(BuildContext context) {
    double total = context.watch<AccumulatedService>().totalCharge;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: _chargeButton,
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0.0),
                      topLeft: Radius.circular(0.0),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [const Text("Charge"), Text("P$total")],
                  ),
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                          serviceList.clear();
                          switch (dropdownValue) {
                            case "All":
                              getAllList();
                              break;
                            case "Full-Service":
                              getFullServiceList();
                              break;
                            case "Partial-Service":
                              getPartialServiceList();
                              break;
                            case "Commodities":
                              getCommoditiesList();
                              break;
                            default:
                              break;
                          }
                        });
                      },
                      items: kCategories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: serviceList.length,
                        itemBuilder: (BuildContext context, int index) {
                          LaundryService service = serviceList[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //search if already existed
                                  context
                                      .read<AccumulatedService>()
                                      .addTicket();
                                  context
                                      .read<AccumulatedService>()
                                      .updateItemListAdd(ItemReceived(
                                          amount: 1, item: service));
                                  context
                                      .read<AccumulatedService>()
                                      .addTotalCharge(service.price);
                                },
                                child: ListTile(
                                  leading: CircleAvatar(child: Text(context.read<AccumulatedService>().getAmount(service.service).toString(), style: const TextStyle(fontSize: 20),)),
                                  title: Text(service.service),
                                  subtitle: Text("per: ${service.unit}"),
                                  trailing: Text("P${service.price}"),
                                ),
                              ),
                              const Divider()
                            ],
                          );
                        }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _chargeButton() {
    if(context.read<AccumulatedService>().items.isEmpty) return null;

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ChargeScreen()));
  }
}
