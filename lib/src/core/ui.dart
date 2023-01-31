part of 'config.dart';

typedef BarcodeItemBuilder = Widget Function(
  BuildContext context,
  List<Barcode> barCode,
);

class UIConfig {
  const UIConfig({
    this.barcodeCanvasBuilder,
    this.barcodeRectItemBuilder,
  });

  final BarcodeItemBuilder? barcodeCanvasBuilder;

  final BarcodeRectItemBuilder? barcodeRectItemBuilder;
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
