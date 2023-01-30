part of 'config.dart';

class BarcodeConfig {
  const BarcodeConfig({
    this.formats = const [BarcodeFormat.all],
  });

  final List<BarcodeFormat> formats;

  BarcodeConfig copyWith({
    List<BarcodeFormat>? formats,
  }) {
    return BarcodeConfig(
      formats: formats ?? this.formats,
    );
  }
}
