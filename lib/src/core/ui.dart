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

Widget defaultBuildBarcodeRect(
  BuildContext context,
  BarcodeData barcodeData,
  UIConfig config,
) {
  return BarcodeRectWidget(
    uiConfig: config,
    barcodeData: barcodeData,
  );
}
