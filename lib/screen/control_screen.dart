import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ControlScreen extends StatefulWidget {
  final BluetoothClassic? classic;
  final BluetoothDevice? bleDevice;
  final bool isClassic;

  const ControlScreen({
    super.key,
    this.classic,
    this.bleDevice,
    required this.isClassic,
  });

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  double speed = 50;

  send(String cmd) async {
    if (widget.isClassic) {
      widget.classic!.write(cmd);
    } else {
      var services = await widget.bleDevice!.discoverServices();
      for (var s in services) {
        for (var c in s.characteristics) {
          if (c.properties.write) {
            await c.write(cmd.codeUnits, withoutResponse: true);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Car Control")),

      body: Column(
        children: [
          const SizedBox(height: 20),

          // Joystick
          Joystick(
            listener: (details) {
              if (details.y < -0.5) send("F");
              else if (details.y > 0.5) send("B");
              else if (details.x < -0.5) send("L");
              else if (details.x > 0.5) send("R");
            },
          ),

          const SizedBox(height: 20),
          Text("Speed: ${speed.toInt()}"),

          Slider(
            value: speed,
            min: 0,
            max: 100,
            onChanged: (v) {
              setState(() => speed = v);
              send("S${v.toInt()}");
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () => send("F"), child: const Text("Forward")),
              ElevatedButton(onPressed: () => send("B"), child: const Text("Back")),
              ElevatedButton(onPressed: () => send("S"), child: const Text("Stop")),
            ],
          )
        ],
      ),
    );
  }
}
