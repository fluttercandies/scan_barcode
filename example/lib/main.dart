import 'package:example/examples/barcode_list_dialog.dart';
import 'package:example/examples/change_camera_config_example.dart';
import 'package:example/examples/change_qrcode_rect.dart';
import 'package:example/examples/scan_and_pop_page_example.dart';
import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

import 'examples/show_dialog_example.dart';

void main() {
  // showLog();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Camera Example'),
      ),
      body: Center(
        child: Column(
          children: [
            _buildCameraScan(),
            _buildChangeCameraConfig(),
            _buildChangeQrcodeRect(),
            _buildOneShotScan(),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String title, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(title),
        ),
      ),
    );
  }

  Widget buildNavigatorItem(String title, Widget targetWidget) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetWidget),
            );
          },
          child: Text(title),
        ),
      ),
    );
  }

  Widget _buildCameraScan() {
    return buildNavigatorItem(
      'Show dialog when scanned',
      const ShowDialogExample(),
    );
  }

  Widget _buildChangeCameraConfig() {
    return buildNavigatorItem(
      'Change camera config',
      const ChangeCameraConfigExample(),
    );
  }

  Widget _buildChangeQrcodeRect() {
    return buildNavigatorItem(
      'Change qrcode rect',
      const CustomBarcodeOverlayExample(),
    );
  }

  Widget _buildOneShotScan() {
    return buildButton(
      'One shot scan',
      () async {
        final barcodes = await Navigator.push<List<Barcode>>(
          context,
          MaterialPageRoute(
            builder: (context) => const ScanAndPopPageExample(),
          ),
        );
        if (barcodes == null) return;
        showBarcodeListDialog(context, barcodes);
      },
    );
  }
}
