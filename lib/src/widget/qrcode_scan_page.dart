import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({
    Key? key,
    required this.title,
    required this.onHandleBarcodeList,
    this.config,
    this.controller,
  }) : super(key: key);

  final String title;
  final OnHandleBarcodeList onHandleBarcodeList;
  final ScanValue? config;
  final BarcodeController? controller;

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
        scanValue: widget.config ?? ScanValue(),
        onHandleBarcodeList: (List<Barcode> barCode) {
          return widget.onHandleBarcodeList(barCode);
        },
      ),
    );
  }
}
