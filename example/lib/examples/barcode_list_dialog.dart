import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_barcode/scan_barcode.dart';

Future<void> showBarcodeListDialog(
    BuildContext context, List<Barcode> barcodeList) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Barcode list'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final barcode in barcodeList)
            ListTile(
              title: Text(barcode.rawValue ?? ''),
              subtitle:
                  Text('type: ${barcode.type}, format: ${barcode.format}'),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: barcode.rawValue ?? ''),
                  );
                },
              ),
            ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
