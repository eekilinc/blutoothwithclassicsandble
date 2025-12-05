import 'package:flutter/material.dart';
import 'classic_screen.dart';
import 'ble_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Control")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              child: const Text("Bluetooth Classic (HC-06)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClassicScreen()),
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              child: const Text("Bluetooth BLE (HC-06 LE)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BleScreen()),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
