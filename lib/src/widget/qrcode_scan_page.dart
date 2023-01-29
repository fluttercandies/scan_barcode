import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

typedef OnHandleBarcodeList = Future<void> Function(List<Barcode> barCode);

class QrcodeScanPage extends StatefulWidget {
  const QrcodeScanPage({
    Key? key,
    required this.onHandleBarcodeList,
  }) : super(key: key);

  final OnHandleBarcodeList onHandleBarcodeList;

  @override
  State<QrcodeScanPage> createState() => _QrcodeScanPageState();
}

class _QrcodeScanPageState extends State<QrcodeScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Camera Example'),
      ),
      body: QRWidget(
        onHandleBarcodeList: (List<Barcode> barCode) {
          return widget.onHandleBarcodeList(barCode);
        },
      ),
    );
  }
}
