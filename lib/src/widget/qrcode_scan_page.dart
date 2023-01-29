import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

class QrcodeScanPage extends StatefulWidget {
  const QrcodeScanPage({Key? key}) : super(key: key);

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
        onHandleBarcodeList: (List<Barcode> barCode) async {},
      ),
    );
  }
}
