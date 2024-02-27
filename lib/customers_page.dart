import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pos_cellular/constance.dart';
import 'package:url_launcher/url_launcher.dart';

import 'class/customer.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<Customer> customers = [];

  @override
  void initState() {
    boxCustomer.values.map((e) => customers.add(e)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (BuildContext context, index) {
            Customer customer = customers[index];
            return Card(
              child: Slidable(
                key: ValueKey(index),
                startActionPane: ActionPane(
                  extentRatio:1,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed:(context){
                        boxCustomer.delete(customer.contactNumber);
                        setState(() {
                          customers.removeAt(index);
                        });
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (context){

                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.save,
                      label: 'Save',
                    ),
                    SlidableAction(
                      // An action can be bigger than the others.
                      onPressed: (context)async{
                        final Uri launchUri = Uri(
                          scheme: 'tel',
                          path: customer.contactNumber,
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
                              'sms:${customer.contactNumber} ?body=$message');
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
                  leading: CircleAvatar(
                    child: Text(customer.name[0].toUpperCase()),
                  ),
                  title: Text(customer.name),
                  subtitle: Text(customer.contactNumber),
                ),
              ),
            );
          }),
    );
  }
}

enum CustomerSetting { clearCustomer }
