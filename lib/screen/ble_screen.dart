import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'control_screen.dart';

class BleScreen extends StatefulWidget {
  const BleScreen({super.key});

  @override
  State<BleScreen> createState() => _BleScreenState();
}

class _BleScreenState extends State<BleScreen> {
  List<ScanResult> devices = [];

  scan() {
    devices.clear();
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() => devices = results);
    });
  }

  connect(ScanResult r) async {
    await r.device.connect();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ControlScreen(
          bleDevice: r.device,
          isClassic: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BLE Scan")),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: const Icon(Icons.search),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(devices[i].device.name),
            subtitle: Text(devices[i].device.id.id),
            onTap: () => connect(devices[i]),
          );
        },
      ),
    );
  }
}
