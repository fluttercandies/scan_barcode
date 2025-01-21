import 'package:flutter/material.dart';
import 'package:scan_barcode/scan_barcode.dart';

typedef BarcodeOverlayBuilder = Widget Function(
  BuildContext context,
  Barcode barcode, {
  BarcodeController? controller,
});

class BarcodeRectWidget extends StatelessWidget {
  const BarcodeRectWidget({
    Key? key,
    required this.barcodeData,
    required this.uiConfig,
    required this.controller,
  }) : super(key: key);

  final BarcodeData? barcodeData;
  final UIConfig uiConfig;
  final BarcodeController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) => LayoutBuilder(
        builder: (context, constraints) {
          var data = barcodeData;
          if (data == null) return Container();
          final imageSize = data.image.metadata?.fixedSize;
          if (imageSize == null) return Container();
          final barcodeList = data.barcodeList;
          if (barcodeList.isEmpty) return Container();

          final width = imageSize.width;
          final height = imageSize.height;

          final scaleX = constraints.maxWidth / width;
          final scaleY = constraints.maxHeight / height;

          return Stack(
            children: [
              ...barcodeList
                  .map((barcode) => _buildBarcode(
                        context,
                        barcode,
                        scaleX,
                        scaleY,
                        controller,
                      ))
                  .whereType<Widget>()
            ],
          );
        },
      ),
    );
  }

  Widget? _buildBarcode(
    BuildContext context,
    Barcode barcode,
    double scaleX,
    double scaleY,
    BarcodeController controller,
  ) {
    final rect = barcode.boundingBox;

    if (rect == null) return null;

    final left = rect.left * scaleX;
    final top = rect.top * scaleY;
    final width = rect.width * scaleX;
    final height = rect.height * scaleY;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: _buildItem(context, barcode, controller),
    );
  }

  Widget _buildItem(
    BuildContext context,
    Barcode barcode,
    BarcodeController controller,
  ) {
    final barcodeRectItemBuilder = uiConfig.barcodeOverlayBuilder;

    if (barcodeRectItemBuilder != null) {
      return barcodeRectItemBuilder(
        context,
        barcode,
        controller: controller,
      );
    }

    if (!controller.isScanning) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }
}
