import 'package:example/examples/change_camera_config_example.dart';
import 'package:example/examples/change_qrcode_rect.dart';
import 'package:flutter/material.dart';

import 'examples/show_dialog_example.dart';

void main() {
  // showLog();
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
            _buildChangeCameraConfig(),
            _buildChangeQrcodeRect(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraScan() {
    return buildNavigatorItem(
      'Show dialog when scanned',
      const ShowDialogExample(),
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

  Widget _buildChangeCameraConfig() {
    return buildNavigatorItem(
      'Change camera config',
      const ChangeCameraConfigExample(),
    );
  }

  Widget _buildChangeQrcodeRect() {
    return buildNavigatorItem(
      'Change qrcode rect',
      const ChangeQrcodeRectExample(),
    );
  }
}
