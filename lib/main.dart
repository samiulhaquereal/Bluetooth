import 'package:bluetooth/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothPage(),
    );
  }
}

class BluetoothPage extends StatelessWidget {
  final BluetoothController bluetoothController = Get.put(BluetoothController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Column(
        children: [
          Obx(() {
            return bluetoothController.isScanning.value
                ? CircularProgressIndicator()
                : SizedBox.shrink();
          }),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: bluetoothController.scanResults.length,
                itemBuilder: (context, index) {
                  final result = bluetoothController.scanResults[index];
                  return ListTile(
                    title: Text(result.device.name.isNotEmpty ? result.device.name  : 'Unknown device'),
                    subtitle: Text(result.device.id.toString()),
                    trailing: Text(result.rssi.toString() + ' dBm'),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
