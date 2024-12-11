import 'package:code_crack/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpAddress extends StatefulWidget {
  const IpAddress({super.key});

  @override
  State<IpAddress> createState() => _IpAddressState();
}

class _IpAddressState extends State<IpAddress> {

  final TextEditingController ipAddressField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text("Input Ip Address"), leading: IconButton(onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const Login();
            },
          ),
        );
      }, icon: const Icon(Icons.arrow_back)),backgroundColor: Colors.transparent,),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            TextField(
              controller: ipAddressField,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "IP Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            FilledButton(onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('ipaddress', ipAddressField.text);
              print(ipAddressField.text);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Login();
                  },
                ),
              );
            }, child: const Text("Submit"))
          ],),
        ),
      ),
    );
  }
}
