part of 'config.dart';

typedef BarcodeItemBuilder = Widget Function(
  BuildContext context,
  List<Barcode> barCode,
);

class UIConfig {
  const UIConfig({
    this.barcodeOverlayBuilder,
  });

  final BarcodeOverlayBuilder? barcodeOverlayBuilder;
}
