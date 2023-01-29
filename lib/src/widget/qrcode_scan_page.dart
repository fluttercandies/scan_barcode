import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

typedef OnHandleBarcodeList = Future<void> Function(List<Barcode> barCode);

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({
    Key? key,
    required this.onHandleBarcodeList,
  }) : super(key: key);

  final OnHandleBarcodeList onHandleBarcodeList;

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Camera Example'),
      ),
      body: BarcodeWidget(
        onHandleBarcodeList: (List<Barcode> barCode) {
          return widget.onHandleBarcodeList(barCode);
        },
      ),
    );
  }
}
