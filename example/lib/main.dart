import 'package:flutter/material.dart';
import 'package:qr_camera/qr_camera.dart';

void main() {
  showLog();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Camera Example'),
      ),
      body: Center(
        child: Column(
          children: [
            _buildCameraScan(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraScan() {
    return buildNavigatorItem(
      'Show dialog ',
      BarcodeScanPage(
        title: 'Show dialog to show barcode list',
        onHandleBarcodeList: (List<Barcode> barCode) async {
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
                      subtitle: Text(
                          'type: ${barcode.type}, format: ${barcode.format}'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildNavigatorItem(String title, Widget targetWidget) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetWidget),
            );
          },
          child: Text(title),
        ),
      ),
    );
  }
}
