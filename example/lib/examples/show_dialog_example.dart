import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_barcode/scan_barcode.dart';

class ShowDialogExample extends StatelessWidget {
  const ShowDialogExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarcodeScanPage(
      title: 'Show dialog when scanned',
      onHandleBarcodeList: (List<Barcode> barCode) async {
        if (barCode.isEmpty) return;
        await showBarcodeListDialog(context, barCode); // The await is important, if you don't await, multiple dialogs will be shown.
      },
    );
  }

  Future<void> showBarcodeListDialog(
      BuildContext context, List<Barcode> barCode) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Barcode list'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final barcode in barCode)
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
}
