import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({
    Key? key,
    required this.title,
    required this.onHandleBarcodeList,
    this.config,
  }) : super(key: key);

  final String title;
  final OnHandleBarcodeList onHandleBarcodeList;
  final ScanConfig? config;

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BarcodeWidget(
        config: widget.config ?? ScanConfig(),
        onHandleBarcodeList: (List<Barcode> barCode) {
          return widget.onHandleBarcodeList(barCode);
        },
      ),
    );
  }
}
