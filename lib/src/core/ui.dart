part of 'config.dart';

typedef BarcodeCanvasBuilder = Widget Function(
  BuildContext context,
  List<Barcode> barCode,
  Widget child,
);

class UIConfig {
  const UIConfig({
    this.barcodeCanvasBuilder,
  });

  final BarcodeCanvasBuilder? barcodeCanvasBuilder;
}
