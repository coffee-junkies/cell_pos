import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pos_cellular/constance.dart';
import 'package:pos_cellular/providers/accumulated_service.dart';
import 'package:pos_cellular/screens/navigation_drawer.dart';
import 'package:provider/provider.dart';
import 'package:dart_casing/dart_casing.dart';

import '../class/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = UserSimplePreference.getUsername() ?? "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("WashBox", style: kLoginText,),
                  const Gap(20),
                  Text("Welcome back,", style: kLoginText,),
                  const Gap(5),
                  Text("Enter your name to continue", style: kLoginText),
                  const Gap(5),
                  Text("to WashBox", style: kLoginText),
                  const Gap(20),
                  Expanded(
                    child: TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(
                        labelText: 'Staff Name',
                      ),
                      onChanged: (name) =>
                          setState(() {
                            this.name = name;
                          }),
                    ),
                  ),
                  TextButton(
                      onPressed: _continue, child: const Text("Continue"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _continue() async {
    await UserSimplePreference.setUsername(name);
    if (mounted) {
      context.read<AccumulatedService>().staffName = Casing.titleCase(name);
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const NavigationDrawerScreen()));
    }
  }
}

