import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothController extends GetxController {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  var scanResults = <ScanResult>[].obs;
  var isScanning = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkPermissionsAndScan();
  }

  Future<void> _checkPermissionsAndScan() async {
    bool bluetoothScanGranted = await Permission.bluetoothScan.isGranted;
    bool bluetoothConnectGranted = await Permission.bluetoothConnect.isGranted;
    bool locationGranted = await Permission.locationWhenInUse.isGranted;

    if (bluetoothScanGranted && bluetoothConnectGranted && locationGranted) {
      _startScan();
    } else {
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.locationWhenInUse.request();

      if (await Permission.bluetoothScan.isGranted &&
          await Permission.bluetoothConnect.isGranted &&
          await Permission.locationWhenInUse.isGranted) {
        _startScan();
      } else {
        print("Bluetooth or Location permissions are not granted.");
      }
    }
  }

  void _startScan() {
    if (!isScanning.value) {
      isScanning.value = true;

      // Start scanning and listen to the stream of scan results
      _flutterBlue.scan(timeout: Duration(seconds: 4)).listen(
              (ScanResult scanResult) {
            // Add each scan result to the list if not already present
            if (!scanResults.contains(scanResult)) {
              scanResults.add(scanResult);
            }
          },
          onDone: () {
            isScanning.value = false;
            print("Scan completed");
          },
          onError: (error) {
            print("Scan error: $error");
            isScanning.value = false;
          }
      );
    }
  }
}
