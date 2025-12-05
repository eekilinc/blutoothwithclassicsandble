import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'control_screen.dart';

class ClassicScreen extends StatefulWidget {
  const ClassicScreen({super.key});

  @override
  State<ClassicScreen> createState() => _ClassicScreenState();
}

class _ClassicScreenState extends State<ClassicScreen> {
  BluetoothClassic bluetooth = BluetoothClassic();
  List devices = [];

  scan() async {
    devices = await bluetooth.scanDevices();
    setState(() {});
  }

  connect(device) async {
    bool ok = await bluetooth.connect(device["address"]);
    if (ok && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ControlScreen(
            classic: bluetooth,
            isClassic: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Classic Scan")),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: const Icon(Icons.search),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(devices[i]["name"]),
            subtitle: Text(devices[i]["address"]),
            onTap: () => connect(devices[i]),
          );
        },
      ),
    );
  }
}
